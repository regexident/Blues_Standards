//
//  DeviceInformationManufacturerNameCharacteristic.swift
//  PeripheralsModule
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct DeviceInformationManufacturerName {
    public let string: String
}

public protocol DeviceInformationManufacturerNameCharacteristicDelegate: class {
    func didUpdate(
        name: Result<DeviceInformationManufacturerName, TypesafeCharacteristicError>,
        for characteristic: DeviceInformationManufacturerNameCharacteristic
    )
}

public struct DeviceInformationManufacturerNameTransformer: CharacteristicValueTransformer {

    public typealias Value = DeviceInformationManufacturerName

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationManufacturerNameTransformer.codingError))
        }
        return .ok(DeviceInformationManufacturerName(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationManufacturerNameCharacteristic: TypesafeCharacteristic, TypeIdentifiable {

    public typealias Transformer = DeviceInformationManufacturerNameTransformer

    public let transformer: Transformer = .init()

    public static let identifier = Identifier(string: "2A29")

    public weak var delegate: DeviceInformationManufacturerNameCharacteristicDelegate? = nil

    public let shadow: ShadowCharacteristic

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }

    public var shouldSubscribeToNotificationsAutomatically: Bool {
        return true
    }
}

extension DeviceInformationManufacturerNameCharacteristic: ReadableCharacteristicDelegate {

    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(name: self.transform(data: data), for: self)
    }
}

extension DeviceInformationManufacturerNameCharacteristic: CharacteristicDataSource {

    public func descriptor(
        shadow: Blues.ShadowDescriptor,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
