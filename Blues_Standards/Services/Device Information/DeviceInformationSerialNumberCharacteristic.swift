//
//  DeviceInformationSerialNumberCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

extension DeviceInformation {
    public struct SerialNumber {
        public let string: String
    }
}

extension DeviceInformation.SerialNumber: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension DeviceInformation {
    public struct SerialNumberTransformer: CharacteristicValueTransformer {
        public typealias Value = SerialNumber

        private static let codingError = "Expected UTF-8 encoded string value."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            guard let string = String(data: data, encoding: .utf8) else {
                return .err(.decodingFailed(message: SerialNumberTransformer.codingError))
            }
            return .ok(SerialNumber(string: string))
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }

    public class SerialNumberCharacteristic:
        Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = SerialNumberTransformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A25")

        open override var name: String? {
            return NSLocalizedString(
                "service.device_information.characteristic.serial_number.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'Serial Number' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension DeviceInformation.SerialNumberCharacteristic: StringConvertibleCharacteristicProtocol {}
