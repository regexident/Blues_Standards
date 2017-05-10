//
//  DeviceInformationFirmwareRevisionCharacteristic.swift
//  PeripheralsModule
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct DeviceInformationFirmwareRevision {
    public let string: String
}

public protocol DeviceInformationFirmwareRevisionCharacteristicDelegate: class {
    func didUpdate(
        modelNumber: Result<DeviceInformationFirmwareRevision, TypesafeCharacteristicError>,
        for characteristic: DeviceInformationFirmwareRevisionCharacteristic
    )
}

public struct DeviceInformationFirmwareRevisionTransformer: CharacteristicValueTransformer {

    public typealias Value = DeviceInformationFirmwareRevision

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationFirmwareRevisionTransformer.codingError))
        }
        return .ok(DeviceInformationFirmwareRevision(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationFirmwareRevisionCharacteristic: TypesafeCharacteristic, TypeIdentifiable {

    public typealias Transformer = DeviceInformationFirmwareRevisionTransformer

    public let transformer: Transformer = .init()

    public static let identifier = Identifier(string: "2A26")

    public weak var delegate: DeviceInformationFirmwareRevisionCharacteristicDelegate? = nil

    public let shadow: ShadowCharacteristic

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }

    public var shouldSubscribeToNotificationsAutomatically: Bool {
        return true
    }
}

extension DeviceInformationFirmwareRevisionCharacteristic: ReadableCharacteristicDelegate {

    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(modelNumber: self.transform(data: data), for: self)
    }
}

extension DeviceInformationFirmwareRevisionCharacteristic: CharacteristicDataSource {

    public func descriptor(
        shadow: Blues.ShadowDescriptor,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
