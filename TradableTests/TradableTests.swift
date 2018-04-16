//
//  TradableTests.swift
//  TradableTests
//
//  Created by 1amageek on 2018/02/26.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import XCTest
import FirebaseFirestore
import FirebaseStorage
import FirebaseCore

class FirebaseTest {

    static let shared: FirebaseTest = FirebaseTest()

    init () {
        FirebaseApp.configure()
    }

}


class TradableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        _ = FirebaseTest.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJPY() {

        XCTAssertEqual(Currency.JPY.formatted(10, withSymbol: true), "¥10")
        XCTAssertEqual(Currency.USD.formatted(10, withSymbol: true), "$0.10")

        XCTAssertEqual(Currency.JPY.formatted(10), "10")
        XCTAssertEqual(Currency.USD.formatted(10), "0.1")

        print(Currency.JPY.formatted(10))
        print(Currency.USD.formatted(10))
        print(Currency.JPY.formatted(10, withSymbol: true))
        print(Currency.USD.formatted(10, withSymbol: true))

    }
    
    
}
