//
//  DeviceInformationHardwareRevisionCharacteristic.swift
//  PeripheralsModule
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
        modelNumber: Result<DeviceInformationHardwareRevision, TypesafeCharacteristicError>,
        for characteristic: DeviceInformationHardwareRevisionCharacteristic
    )
}

public struct DeviceInformationHardwareRevisionTransformer: CharacteristicValueTransformer {

    public typealias Value = DeviceInformationHardwareRevision

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationHardwareRevisionTransformer.codingError))
        }
        return .ok(DeviceInformationHardwareRevision(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationHardwareRevisionCharacteristic: TypesafeCharacteristic, TypeIdentifiable {

    public typealias Transformer = DeviceInformationHardwareRevisionTransformer

    public let transformer: Transformer = .init()

    public static let identifier = Identifier(string: "2A27")

    public weak var delegate: DeviceInformationHardwareRevisionCharacteristicDelegate? = nil

    public let shadow: ShadowCharacteristic

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }

    public var shouldSubscribeToNotificationsAutomatically: Bool {
        return true
    }
}

extension DeviceInformationHardwareRevisionCharacteristic: ReadableCharacteristicDelegate {

    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(modelNumber: self.transform(data: data), for: self)
    }
}

extension DeviceInformationHardwareRevisionCharacteristic: CharacteristicDataSource {

    public func descriptor(
        shadow: Blues.ShadowDescriptor,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
