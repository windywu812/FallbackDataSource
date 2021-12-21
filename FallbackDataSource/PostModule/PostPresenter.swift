//
//  PostPresenter.swift
//  FallbackDataSource
//
//  Created by Windy on 21/12/21.
//

import Foundation

class PostPresenter: PostPresenterInput {
    
    weak var delegate: PostPresenterOutput?
    
    private let dataLoader: DataLoader
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func fetchPost() {
        dataLoader.execute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.delegate?.didFetchPost(posts: posts)
            case .failure(let err):
                self.delegate?.didError(message: err.localizedDescription)
            }
        }
    }
    
}
