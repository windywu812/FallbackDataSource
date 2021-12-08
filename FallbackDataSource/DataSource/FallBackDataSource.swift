//
//  FallBackDataSource.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import Foundation

class FallBackDataSource: DataLoader {
    
    private let localDataSource: DataLoader
    private let remoteDataSource: DataLoader
        
    init(localDataSource: DataLoader, remoteDataSource: DataLoader) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func execute(completion: @escaping (Result<[Post], Error>) -> ()) {
        remoteDataSource.execute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure:
                self.localDataSource.execute(completion: completion)
            }
        }
    }
    
}
