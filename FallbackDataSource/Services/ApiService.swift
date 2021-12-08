//
//  ApiService.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import Foundation

class ApiService {
    
    static let shared = ApiService()
    
    private let session = URLSession.shared
    
    func fetch<T: Codable>(url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let response = try jsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch let err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
            
        }.resume()
        
    }
    
}
