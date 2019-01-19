//
//  MasterViewModelTest.swift
//  Cake ListTests
//
//  Created by Angelo Gkiata on 19/01/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest

class MasterViewModelTest: XCTestCase {
    var mockViewModel: MasterViewModel!
    
    override func setUp() {
        super.setUp()
        self.mockViewModel = MasterViewModel(webService: MockWebService(), completion: {
            
        })
    }
    
    override func tearDown() {
        self.mockViewModel = nil
        super.tearDown()
    }
    
    func test_item_count() {
        XCTAssertTrue(self.mockViewModel.itemCount == 3, "Item count is wrong")
    }
    
    func test_title() {
        XCTAssertTrue(self.mockViewModel.title == "Cake - List", "The title has the wrong value")
    }
}

class MockWebService: WebService {
    override func performURLSession<T>(codableType: T.Type, endpoint: String?, completionHandler: @escaping (T?, Error?) -> Void) where T : Decodable, T : Encodable {
        let path = Bundle(for: type(of: self)).path(forResource: "cakes", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let mockResponse = try! JSONDecoder().decode([Cake].self, from: data)
        completionHandler(mockResponse as? T, nil)
    }
}
