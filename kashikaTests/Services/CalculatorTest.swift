//
//  CalculatorTest.swift
//  kashikaTests
//
//  Created by 松本淳之介 on 2020/05/06.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import XCTest
@testable import kashika

class CalculatorTest: XCTestCase {

    func testNormal01() throws {
        let calculator = Calculator()
        let results = try? calculator.calculate("1+2×3")
        XCTAssertEqual(results, 7)
    }

    func testNormal02() throws {
        let calculator = Calculator()
        let results = try? calculator.calculate("2×3+4")
        XCTAssertEqual(results, 10)
    }

    func testNormal03() throws {
        let calculator = Calculator()
        let results = try? calculator.calculate("10÷2+4")
        XCTAssertEqual(results, 9)
    }

    func testNormal04() throws {
         let calculator = Calculator()
         let results = try? calculator.calculate("1.1")
         XCTAssertEqual(results, 330)
     }
}
