//
//  DeviceInformationSoftwareRevisionCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

extension DeviceInformation {
    public struct SoftwareRevision {
        public let string: String
    }
}

extension DeviceInformation.SoftwareRevision: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension DeviceInformation {
    public struct SoftwareRevisionTransformer: CharacteristicValueTransformer {
        public typealias Value = SoftwareRevision

        private static let codingError = "Expected UTF-8 encoded string value."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            guard let string = String(data: data, encoding: .utf8) else {
                return .err(.decodingFailed(message: SoftwareRevisionTransformer.codingError))
            }
            return .ok(SoftwareRevision(string: string))
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }

    public class SoftwareRevisionCharacteristic:
        Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = SoftwareRevisionTransformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A28")

        open override var name: String? {
            return NSLocalizedString(
                "service.device_information.characteristic.software_revision.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'Software Revision' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension DeviceInformation.SoftwareRevisionCharacteristic: StringConvertibleCharacteristicProtocol {}
