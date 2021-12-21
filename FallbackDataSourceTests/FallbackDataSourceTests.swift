//
//  FallbackDataSourceTests.swift
//  FallbackDataSourceTests
//
//  Created by Windy on 21/12/21.
//

import XCTest
@testable import FallbackDataSource

class FallbackDataSourceTests: XCTestCase {

    func test_didFetchData() {
        let spy = SpyPresenter(result: .success([Post(userId: 1, id: 1, title: "Title 1", body: "Body 1")]))
        let sut = ViewController(presenter: spy)
        spy.output = sut
        sut.loadViewIfNeeded()

        let numberOfRows = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_didFetchDataWithError() {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let spy = SpyPresenter(result: .failure(error))
        let sut = TestableViewController(presenter: spy)
        spy.output = sut
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.presentedAlert)
    }
    
    class SpyPresenter: PostPresenterInput {
        
        weak var output: PostPresenterOutput?
        
        private let result: Result<[Post], Error>
        
        init(result: Result<[Post], Error>) {
            self.result = result
        }
        
        func fetchPost() {
            switch result {
            case .success(let posts):
                output?.didFetchPost(posts: posts)
            case .failure(let err):
                output?.didError(message: err.localizedDescription)
            }
        }
        
    }
    
}

private class TestableViewController: ViewController {
    
    var presentedAlert: UIAlertController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
        presentedAlert = viewControllerToPresent as? UIAlertController
    }
    
}
