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
    public struct HardwareRevision {
        public let string: String
    }
}

extension DeviceInformation.HardwareRevision: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension DeviceInformation {
    public struct HardwareRevisionTransformer: CharacteristicValueTransformer {
        public typealias Value = HardwareRevision

        private static let codingError = "Expected UTF-8 encoded string value."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            guard let string = String(data: data, encoding: .utf8) else {
                return .err(.decodingFailed(message: HardwareRevisionTransformer.codingError))
            }
            return .ok(HardwareRevision(string: string))
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }

    public class HardwareRevisionCharacteristic:
        Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = HardwareRevisionTransformer

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

extension DeviceInformation.HardwareRevisionCharacteristic: StringConvertibleCharacteristicProtocol {}
