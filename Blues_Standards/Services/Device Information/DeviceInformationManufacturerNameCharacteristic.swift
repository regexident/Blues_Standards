//
//  DeviceInformationManufacturerNameCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct ManufacturerName {
    public let string: String
}

extension ManufacturerName: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public struct DeviceInformationManufacturerNameTransformer: CharacteristicValueTransformer {
    public typealias Value = ManufacturerName

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationManufacturerNameTransformer.codingError))
        }
        return .ok(ManufacturerName(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationManufacturerNameCharacteristic:
    Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
    public typealias Transformer = DeviceInformationManufacturerNameTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A29")

    open override var name: String? {
        return NSLocalizedString(
            "service.device_information.characteristic.manufacturer_name.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Manufacturer Name' characteristic"
        )
    }

    public weak var delegate: CharacteristicDelegate? = nil
}

extension DeviceInformationManufacturerNameCharacteristic: StringConvertibleCharacteristicProtocol {}
