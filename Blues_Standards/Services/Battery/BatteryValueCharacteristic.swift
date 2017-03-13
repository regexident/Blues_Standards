//
//  BatteryValueCharacteristic.swift
//  PeripheralsModule
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct BatteryValue {
    /// Normalized battery level (0.0 == 0%, 1.0 == 100%)
    public let value: Float
}

public class BatteryValueCharacteristic: DelegatedCharacteristic {

    public static let identifier = Identifier(string: "2A19")
    
    public let shadow: ShadowCharacteristic

    public weak var delegate: CharacteristicDelegate?

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }
}

extension BatteryValueCharacteristic: TypesafeCharacteristic {

    public typealias Value = BatteryValue

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        let expectedSize = 1
        guard data.count == expectedSize else {
            return .err(.decodingFailed(message: "Expected data with \(expectedSize) bytes"))
        }
        return data.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            let byte = buffer[0]
            if byte <= 100 {
                return .ok(BatteryValue(value: Float(byte) / 100.0))
            } else {
                return .err(.decodingFailed(message: "Expected value within 0 and 100 (inclusive)"))
            }
        }
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        var value = value
        return .ok(withUnsafePointer(to: &value) {
            Data(bytes: UnsafePointer($0), count: MemoryLayout.size(ofValue: value))
        })
    }
}

extension BatteryValueCharacteristic: CharacteristicDataSource {

    public func descriptor(shadow: Blues.ShadowDescriptor, forCharacteristic characteristic: Characteristic) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
