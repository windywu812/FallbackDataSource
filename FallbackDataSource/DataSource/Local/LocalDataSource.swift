//
//  LocalDataSource.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import CoreData

class LocalDataSource: DataLoader {
    
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
        
    func execute(completion: @escaping (Result<[Post], Error>) -> ()) {
        coreDataService.retrieveData(completion: completion)
    }
    
}
