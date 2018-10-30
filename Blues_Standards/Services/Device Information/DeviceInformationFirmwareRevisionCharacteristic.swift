//
//  DeviceInformationFirmwareRevisionCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
extension DeviceInformation {
    // Poor man's namespace:
    public enum FirmwareRevision {}
}

extension DeviceInformation.FirmwareRevision {
    public struct Value {
        public let string: String
    }
}

extension DeviceInformation.FirmwareRevision.Value: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension DeviceInformation.FirmwareRevision {
    public struct Transformer: CharacteristicValueTransformer {
        public typealias Value = DeviceInformation.FirmwareRevision.Value
        
        enum Error: Swift.Error {
            case unableToDecodeString(data: Data)
        }
        
        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            guard let string = String(data: data, encoding: .utf8) else {
                return .err(.decodingFailed(error: Error.unableToDecodeString(data: data)))
            }
            return .ok(Value(string: string))
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }

    public class Characteristic:
        Blues.Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = DeviceInformation.FirmwareRevision.Transformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A26")

        open override var name: String? {
            return NSLocalizedString(
                "service.device_information.characteristic.firmware_revision.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'Firmware Revision' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension DeviceInformation.FirmwareRevision.Characteristic: StringConvertibleCharacteristicProtocol {}
