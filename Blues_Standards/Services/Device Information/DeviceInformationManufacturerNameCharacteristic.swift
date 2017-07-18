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

extension DeviceInformation {
    public struct ManufacturerName {
        public let string: String
    }
}

extension DeviceInformation.ManufacturerName: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension DeviceInformation {
    public struct ManufacturerNameTransformer: CharacteristicValueTransformer {
        public typealias Value = ManufacturerName

        private static let codingError = "Expected UTF-8 encoded string value."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            guard let string = String(data: data, encoding: .utf8) else {
                return .err(.decodingFailed(message: ManufacturerNameTransformer.codingError))
            }
            return .ok(ManufacturerName(string: string))
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }

    public class ManufacturerNameCharacteristic:
        Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = ManufacturerNameTransformer

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
}

extension DeviceInformation.ManufacturerNameCharacteristic: StringConvertibleCharacteristicProtocol {}
