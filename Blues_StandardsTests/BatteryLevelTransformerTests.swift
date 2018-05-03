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

    let transformer = Battery.Level.Transformer()

    func testTooShort() {
        let data = Data(bytes: [])
        guard case .err(.decodingFailed(_)) = self.transformer.transform(data: data) else {
            XCTFail("Expected error.")
            return
        }
    }

    func testTooLong() {
        let data = Data(bytes: [0b00000000, 0b00000000])
        guard case .err(.decodingFailed(_)) = self.transformer.transform(data: data) else {
            XCTFail("Expected error.")
            return
        }
    }

    func testZero() {
        let data = Data(bytes: [0b00000000])
        switch self.transformer.transform(data: data) {
        case .ok(let value):
            XCTAssertEqual(value, Battery.Level.Value(value: 0))
        case .err(let error):
            XCTFail("Error: \(error)")
        }
    }

    func testFifty() {
        let data = Data(bytes: [0b00110010])
        switch self.transformer.transform(data: data) {
        case .ok(let value):
            XCTAssertEqual(value, Battery.Level.Value(value: 50))
        case .err(let error):
            XCTFail("Error: \(error)")
        }
    }

    func testHundred() {
        let data = Data(bytes: [0b01100100])
        switch self.transformer.transform(data: data) {
        case .ok(let value):
            XCTAssertEqual(value, Battery.Level.Value(value: 100))
        case .err(let error):
            XCTFail("Error: \(error)")
        }
    }

    func testTwoHundredFiftyFive() {
        let data = Data(bytes: [0b11111111])
        guard case .err(.decodingFailed(_)) = self.transformer.transform(data: data) else {
            XCTFail("Expected error.")
            return
        }
    }
}
