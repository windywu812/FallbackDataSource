//
//  RemoteDataSource.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import Foundation

class RemoteDataSource: DataLoader {
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func execute(completion: @escaping (Result<[Post], Error>) -> ()) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        apiService.fetch(url: url, type: [Post].self, completion: completion)
    }
    
}
