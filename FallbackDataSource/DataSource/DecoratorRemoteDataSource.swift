//
//  DecoratorRemoteDataSource.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import Foundation

class DecoratorRemoteDataSource: DataLoader {
    
    private let decorate: DataLoader
    private let coreDataService: CoreDataService
    
    init(decorate: DataLoader, coreDataService: CoreDataService) {
        self.decorate = decorate
        self.coreDataService = coreDataService
    }
    
    func execute(completion: @escaping (Result<[Post], Error>) -> ()) {
        decorate.execute { result in
            switch result {
            case .success(let posts):
                self.coreDataService.insertData(post: posts)
                completion(.success(posts))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
}
