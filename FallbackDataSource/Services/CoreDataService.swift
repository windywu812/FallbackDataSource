//
//  CoreDataService.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import CoreData

class CoreDataService {
    
    private let moc: NSManagedObjectContext
    
    static let shared: ((NSManagedObjectContext) -> CoreDataService) = { moc in
        return CoreDataService(moc: moc)
    }
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func retrieveData(completion: @escaping (Result<[Post], Error>) -> ()) {
        let request = NSFetchRequest<PostEntity>(entityName: "PostEntity")
        do {
            let result = try self.moc.fetch(request)
            let posts = result.map({
                Post(
                    userId: Int($0.userId),
                    id: Int($0.id),
                    title: $0.title ?? "Empty",
                    body: $0.body ?? "Empty")
            })
            DispatchQueue.main.async {
                completion(.success(posts))
            }
        } catch let err {
            DispatchQueue.main.async {
                completion(.failure(err))
            }
        }
    }
    
    func insertData(post: [Post]) {
        
        post.forEach ({
            let post = PostEntity(context: moc)
            post.id = Int32($0.id)
            post.userId = Int32($0.userId)
            post.title = $0.title
            post.body = $0.body
            moc.insert(post)
        })
        
        do {
            resetAllData()
            try moc.save()
        } catch let err {
            print(err)
        }
    }
    
    func resetAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try moc.execute(batchDelete)
        } catch let err {
            print(err)
        }
    }
    
}
