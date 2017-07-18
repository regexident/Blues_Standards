//
//  DeviceInformationHardwareRevisionCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

extension DeviceInformation {
    // Poor man's namespace:
    public enum HardwareRevision {}
}

extension DeviceInformation.HardwareRevision {
    public struct Value {
        public let string: String
    }
}

extension DeviceInformation.HardwareRevision.Value: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension DeviceInformation.HardwareRevision {
    public struct Transformer: CharacteristicValueTransformer {
        public typealias Value = DeviceInformation.HardwareRevision.Value

        private static let codingError = "Expected UTF-8 encoded string value."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            guard let string = String(data: data, encoding: .utf8) else {
                return .err(.decodingFailed(message: Transformer.codingError))
            }
            return .ok(Value(string: string))
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }
}

extension DeviceInformation.HardwareRevision {
    public class Characteristic:
        Blues.Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = DeviceInformation.HardwareRevision.Transformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A27")

        open override var name: String? {
            return NSLocalizedString(
                "service.device_information.characteristic.hardware_revision.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'Hardware Revision' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension DeviceInformation.HardwareRevision.Characteristic: StringConvertibleCharacteristicProtocol {}
