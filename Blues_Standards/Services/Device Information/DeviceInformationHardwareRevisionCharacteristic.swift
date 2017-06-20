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

public struct DeviceInformationHardwareRevision {
    public let string: String
}

public protocol DeviceInformationHardwareRevisionCharacteristicDelegate: class {
    func didUpdate(
        hardwareRevision: Result<DeviceInformationHardwareRevision, TypedCharacteristicError>,
        for characteristic: DeviceInformationHardwareRevisionCharacteristic
    )
}

public struct DeviceInformationHardwareRevisionTransformer: CharacteristicValueTransformer {
    public typealias Value = DeviceInformationHardwareRevision

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationHardwareRevisionTransformer.codingError))
        }
        return .ok(DeviceInformationHardwareRevision(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationHardwareRevisionCharacteristic: Characteristic, TypedCharacteristic, TypeIdentifiable {
    public typealias Transformer = DeviceInformationHardwareRevisionTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A27")

    public weak var delegate: DeviceInformationHardwareRevisionCharacteristicDelegate? = nil

    open override var shouldSubscribeToNotificationsAutomatically: Bool {
        return false
    }
}

extension DeviceInformationHardwareRevisionCharacteristic: ReadableCharacteristicDelegate {
    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(hardwareRevision: self.transform(data: data), for: self)
    }
}

extension DeviceInformationHardwareRevisionCharacteristic: CharacteristicDataSource {
    public func descriptor(
        with identifier: Identifier,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(identifier: identifier, characteristic: characteristic)
    }
}
