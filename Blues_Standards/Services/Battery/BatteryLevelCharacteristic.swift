//
//  BatteryLevelCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
extension Battery {
    // Poor man's namespace:
    public enum Level {}
}

extension Battery.Level {
    public struct Value {
        /// Normalized battery level (0 == 0%, 100 == 100%)
        public let value: UInt8

        public static let empty: Value = .init(value: 0)
        public static let full: Value = .init(value: 100)

        public init(value: UInt8) {
            self.value = value
        }
    }
}

extension Battery.Level.Value: Equatable {
    public static func == (lhs: Battery.Level.Value, rhs: Battery.Level.Value) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Battery.Level.Value: Comparable {
    public static func < (lhs: Battery.Level.Value, rhs: Battery.Level.Value) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Battery.Level.Value: CustomStringConvertible {
    public var description: String {
        return "\(self.value) %"
    }
}

extension Battery.Level {
    public struct Transformer: CharacteristicValueTransformer {
        public typealias Value = Battery.Level.Value

        private static let codingError = "Expected value within 0 and 100 (inclusive)."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            let expectedLength = 1
            guard data.count == expectedLength else {
                return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
            }
            return data.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
                let byte = buffer[0]
                if byte <= 100 {
                    return .ok(Value(value: byte))
                } else {
                    return .err(.decodingFailed(message: Transformer.codingError))
                }
            }
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }
}

extension Battery.Level {
    public class Characteristic:
        Blues.Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = Battery.Level.Transformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A19")

        open override var name: String? {
            return NSLocalizedString(
                "service.battery.characteristic.battery_level.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'Battery Level' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension Battery.Level.Characteristic: StringConvertibleCharacteristicProtocol {}
