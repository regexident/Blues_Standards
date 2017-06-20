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

public struct DeviceInformationSoftwareRevision {
    public let string: String
}

public protocol DeviceInformationSoftwareRevisionCharacteristicDelegate: class {
    func didUpdate(
        softwareRevision: Result<DeviceInformationSoftwareRevision, TypedCharacteristicError>,
        for characteristic: DeviceInformationSoftwareRevisionCharacteristic
    )
}

public struct DeviceInformationSoftwareRevisionTransformer: CharacteristicValueTransformer {
    public typealias Value = DeviceInformationSoftwareRevision

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationSoftwareRevisionTransformer.codingError))
        }
        return .ok(DeviceInformationSoftwareRevision(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationSoftwareRevisionCharacteristic: Characteristic, TypedCharacteristic, TypeIdentifiable {
    public typealias Transformer = DeviceInformationSoftwareRevisionTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A28")

    public weak var delegate: DeviceInformationSoftwareRevisionCharacteristicDelegate? = nil

    open override var shouldSubscribeToNotificationsAutomatically: Bool {
        return false
    }
}

extension DeviceInformationSoftwareRevisionCharacteristic: ReadableCharacteristicDelegate {
    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(softwareRevision: self.transform(data: data), for: self)
    }
}

extension DeviceInformationSoftwareRevisionCharacteristic: CharacteristicDataSource {
    public func descriptor(
        with identifier: Identifier,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(identifier: identifier, characteristic: characteristic)
    }
}
