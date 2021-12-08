//
//  Posts.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
