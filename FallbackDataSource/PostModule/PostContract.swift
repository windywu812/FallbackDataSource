//
//  PostContract.swift
//  FallbackDataSource
//
//  Created by Windy on 21/12/21.
//

import Foundation

protocol PostPresenterOutput: AnyObject {
    func didFetchPost(posts: [Post])
    func didError(message: String)
}

protocol PostPresenterInput {
    func fetchPost()
}

protocol DataLoader {
    func execute(completion: @escaping (Result<[Post], Error>) -> ())
}
