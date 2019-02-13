//
//  BatteryLevelCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct BatteryLevel {
    /// Normalized battery level (0 == 0%, 100 == 100%)
    public let value: UInt8
}

extension BatteryLevel: Equatable {
    public static func == (lhs: BatteryLevel, rhs: BatteryLevel) -> Bool {
        return lhs.value == rhs.value
    }
}

extension BatteryLevel: CustomStringConvertible {
    public var description: String {
        return "\(self.value)%"
    }
}

public struct BatteryLevelDecoder: ValueDecoder {
    public typealias Value = BatteryLevel
    
    public typealias Input = Data
    
    public func decode(_ input: Input) -> Blues.Result<Value, Blues.DecodingError> {
        let expectedLength = 1
        guard input.count == expectedLength else {
            let message = "Expected data of \(expectedLength) bytes, found \(input.count)."
            return .err(.init(message: message))
        }
        return input.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            let byte = buffer[0]
            if byte <= 100 {
                return .ok(Value(value: byte))
            } else {
                let message = "Expected value within 0 and 100 (inclusive), found \(byte)."
                return .err(.init(message: message))
            }
        }
    }
}

public class BatteryLevelCharacteristic:
Blues.Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "2A19")
    
    public weak var delegate: CharacteristicDelegate? = nil
    
    public override init(identifier: Identifier, service: ServiceProtocol) {
        super.init(identifier: identifier, service: service)
        
        self.name = NSLocalizedString(
            "service.battery.characteristic.battery_level.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Battery Level' characteristic"
        )
    }
}

extension BatteryLevelCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = BatteryLevelDecoder
    
    public var decoder: Decoder {
        return .init()
    }
}

extension BatteryLevelCharacteristic: StringConvertibleCharacteristicProtocol {}
