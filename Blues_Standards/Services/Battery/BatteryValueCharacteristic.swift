//
//  BatteryValueCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct BatteryValue {
    /// Normalized battery level (0 == 0%, 100 == 100%)
    public let value: UInt8
}

extension BatteryValue: Equatable {
    public static func == (lhs: BatteryValue, rhs: BatteryValue) -> Bool {
        return lhs.value == rhs.value
    }
}

extension BatteryValue: CustomStringConvertible {
    public var description: String {
        return "\(self.value)%"
    }
}

public struct BatteryValueTransformer: CharacteristicValueTransformer {
    public typealias Value = BatteryValue

    private static let codingError = "Expected value within 0 and 100 (inclusive)."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        let expectedLength = 1
        guard data.count == expectedLength else {
            return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
        }
        return data.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            let byte = buffer[0]
            if byte <= 100 {
                return .ok(BatteryValue(value: byte))
            } else {
                return .err(.decodingFailed(message: BatteryValueTransformer.codingError))
            }
        }
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class BatteryValueCharacteristic:
    Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
    public typealias Transformer = BatteryValueTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A19")

    public weak var delegate: CharacteristicDelegate? = nil

    open override var shouldSubscribeToNotificationsAutomatically: Bool {
        return false
    }
}
