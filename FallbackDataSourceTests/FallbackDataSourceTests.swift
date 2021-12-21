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
        let stub = StubDataLoader(result: .success([
            Post(userId: 1, id: 1, title: "Title 1", body: "Body 1")
        ]))
        let sut = ViewController(dataLoader: stub)
        sut.loadViewIfNeeded()

        let numberOfRows = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_didRefreshData() {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let stub = StubDataLoader(result: .failure(error))
        let sut = TestableViewController(dataLoader: stub)
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.presentedAlert)
    }
    
    class StubDataLoader: DataLoader {
        
        private let result: Result<[Post], Error>
        
        init(result: Result<[Post], Error>) {
            self.result = result
        }
        
        func execute(completion: @escaping (Result<[Post], Error>) -> ()) {
            completion(result)
        }
    }
    
}

private class TestableViewController: ViewController {
    
    var presentedAlert: UIAlertController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
        presentedAlert = viewControllerToPresent as? UIAlertController
    }
    
}
