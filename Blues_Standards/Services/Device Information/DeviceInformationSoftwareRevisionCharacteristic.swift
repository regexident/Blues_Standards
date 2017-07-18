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

public struct SoftwareRevision {
    public let string: String
}

extension SoftwareRevision: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public struct DeviceInformationSoftwareRevisionTransformer: CharacteristicValueTransformer {
    public typealias Value = SoftwareRevision

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationSoftwareRevisionTransformer.codingError))
        }
        return .ok(SoftwareRevision(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationSoftwareRevisionCharacteristic:
    Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
    public typealias Transformer = DeviceInformationSoftwareRevisionTransformer

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

extension DeviceInformationSoftwareRevisionCharacteristic: StringConvertibleCharacteristicProtocol {}
