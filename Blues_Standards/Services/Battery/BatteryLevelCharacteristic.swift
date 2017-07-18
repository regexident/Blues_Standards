//
//  BatteryLevelCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

extension Battery {
    public struct Level {
        /// Normalized battery level (0 == 0%, 100 == 100%)
        public let value: UInt8
    }
}

extension Battery.Level: Equatable {
    public static func == (lhs: Battery.Level, rhs: Battery.Level) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Battery.Level: CustomStringConvertible {
    public var description: String {
        return "\(self.value)%"
    }
}

extension Battery {
    public struct LevelTransformer: CharacteristicValueTransformer {
        public typealias Value = Battery.Level

        private static let codingError = "Expected value within 0 and 100 (inclusive)."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            let expectedLength = 1
            guard data.count == expectedLength else {
                return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
            }
            return data.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
                let byte = buffer[0]
                if byte <= 100 {
                    return .ok(Level(value: byte))
                } else {
                    return .err(.decodingFailed(message: LevelTransformer.codingError))
                }
            }
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }

    public class LevelCharacteristic:
        Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = LevelTransformer

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

extension Battery.LevelCharacteristic: StringConvertibleCharacteristicProtocol {}
