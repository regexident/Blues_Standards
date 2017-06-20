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

public struct DeviceInformationModelNumber {
    public let string: String
}

public protocol DeviceInformationModelNumberCharacteristicDelegate: class {
    func didUpdate(
        modelNumber: Result<DeviceInformationModelNumber, TypedCharacteristicError>,
        for characteristic: DeviceInformationModelNumberCharacteristic
    )
}

public struct DeviceInformationModelNumberTransformer: CharacteristicValueTransformer {
    public typealias Value = DeviceInformationModelNumber

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationModelNumberTransformer.codingError))
        }
        return .ok(DeviceInformationModelNumber(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationModelNumberCharacteristic: Characteristic, TypedCharacteristic, TypeIdentifiable {
    public typealias Transformer = DeviceInformationModelNumberTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A24")

    public weak var delegate: DeviceInformationModelNumberCharacteristicDelegate? = nil

    open override var shouldSubscribeToNotificationsAutomatically: Bool {
        return false
    }
}

extension DeviceInformationModelNumberCharacteristic: ReadableCharacteristicDelegate {
    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(modelNumber: self.transform(data: data), for: self)
    }
}

extension DeviceInformationModelNumberCharacteristic: CharacteristicDataSource {
    public func descriptor(
        with identifier: Identifier,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(identifier: identifier, characteristic: characteristic)
    }
}
