//
//  DeviceInformationSystemIDCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct SystemID {
    public let manufacturerIdentifier: UInt64
    public let organizationallyUniqueIdentifier: UInt32
}

extension SystemID: CustomStringConvertible {
    public var description: String {
        return [
            "manufacturerIdentifier = \(self.manufacturerIdentifier)",
            "organizationallyUniqueIdentifier = \(self.organizationallyUniqueIdentifier)",
        ].joined(separator: ", ")
    }
}

public struct DeviceInformationSystemIDTransformer: CharacteristicValueTransformer {
    public typealias Value = SystemID

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        let expectedLength = 8
        guard data.count == expectedLength else {
            return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
        }
        return data.withUnsafeBytes { (buffer: UnsafePointer<UInt64>) in
            let bytes = UInt64(bigEndian: buffer[0])
            return .ok(SystemID(
                manufacturerIdentifier: bytes & (~0 >> 24),
                organizationallyUniqueIdentifier: UInt32(bytes >> 40)
            ))
        }
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationSystemIDCharacteristic:
    Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
    public typealias Transformer = DeviceInformationSystemIDTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A23")

    open override var name: String? {
        return NSLocalizedString(
            "service.device_information.characteristic.system_id.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'System ID' characteristic"
        )
    }

    public weak var delegate: CharacteristicDelegate? = nil
}

extension DeviceInformationSystemIDCharacteristic: StringConvertibleCharacteristicProtocol {}
