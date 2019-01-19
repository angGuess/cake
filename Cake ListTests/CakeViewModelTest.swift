//
//  CakeViewModelTest.swift
//  Cake ListTests
//
//  Created by Angelo Gkiata on 19/01/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest

class CakeViewModelTest: XCTestCase {
    var mockCakeViewModel: CakeViewModel!
    
    override func setUp() {
        super.setUp()
        let path = Bundle(for: type(of: self)).path(forResource: "cake", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let mockCake = try! JSONDecoder().decode(Cake.self, from: data)
        self.mockCakeViewModel = CakeViewModel(cake: mockCake)
    }
    
    override func tearDown() {
        self.mockCakeViewModel = nil
        super.tearDown()
    }
    
    func test_details() {
        XCTAssertEqual("Lemon cheesecake", self.mockCakeViewModel.title, "The title is wrong ")
        
        XCTAssertEqual("A cheesecake made of lemon", self.mockCakeViewModel.desc, "The description is wrong")
    }
    
    func test_image_url() {
        XCTAssertTrue(!self.mockCakeViewModel.safeUrl.isEmpty, "The url is wrong")
    }
}
