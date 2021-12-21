//
//  PostContract.swift
//  FallbackDataSource
//
//  Created by Windy on 21/12/21.
//

import Foundation

protocol DataLoader {
    func execute(completion: @escaping (Result<[Post], Error>) -> ())
}
