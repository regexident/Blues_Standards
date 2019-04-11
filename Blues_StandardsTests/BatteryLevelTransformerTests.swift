//
//  BatteryLevelTransformerTests.swift
//  Blues_StandardsTests
//
//  Created by Vincent Esche on 20/03/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import XCTest

import Blues

@testable import Blues_Standards

class BatteryLevelTransformerTests: XCTestCase {

    let transformer = BatteryLevelDecoder()

    func testTooShort() {
        let data = Data(bytes: [])
        guard case .failure = self.transformer.decode(data) else {
            XCTFail("Expected error.")
            return
        }
    }

    func testTooLong() {
        let data = Data(bytes: [0b00000000, 0b00000000])
        guard case .failure = self.transformer.decode(data) else {
            XCTFail("Expected error.")
            return
        }
    }

    func testZero() {
        let data = Data(bytes: [0b00000000])
        switch self.transformer.decode(data) {
        case .success(let value):
            XCTAssertEqual(value, BatteryLevel(value: 0))
        case .failure(let error):
            XCTFail("Error: \(error)")
        }
    }

    func testFifty() {
        let data = Data(bytes: [0b00110010])
        switch self.transformer.decode(data) {
        case .success(let value):
            XCTAssertEqual(value, BatteryLevel(value: 50))
        case .failure(let error):
            XCTFail("Error: \(error)")
        }
    }

    func testHundred() {
        let data = Data(bytes: [0b01100100])
        switch self.transformer.decode(data) {
        case .success(let value):
            XCTAssertEqual(value, BatteryLevel(value: 100))
        case .failure(let error):
            XCTFail("Error: \(error)")
        }
    }

    func testTwoHundredFiftyFive() {
        let data = Data(bytes: [0b11111111])
        guard case .failure = self.transformer.decode(data) else {
            XCTFail("Expected error.")
            return
        }
    }
}
