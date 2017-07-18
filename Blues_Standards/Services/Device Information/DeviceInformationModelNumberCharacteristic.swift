//
//  DeviceInformationModelNumberCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct ModelNumber {
    public let string: String
}

extension ModelNumber: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public struct DeviceInformationModelNumberTransformer: CharacteristicValueTransformer {
    public typealias Value = ModelNumber

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationModelNumberTransformer.codingError))
        }
        return .ok(ModelNumber(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationModelNumberCharacteristic:
    Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
    public typealias Transformer = DeviceInformationModelNumberTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A24")

    open override var name: String? {
        return NSLocalizedString(
            "service.device_information.characteristic.model_number.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Model Number' characteristic"
        )
    }

    public weak var delegate: CharacteristicDelegate? = nil
}

extension DeviceInformationModelNumberCharacteristic: StringConvertibleCharacteristicProtocol {}
