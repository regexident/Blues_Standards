//
//  DeviceInformationSerialNumberCharacteristic.swift
//  PeripheralsModule
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct DeviceInformationSerialNumber {
    public let string: String
}

public protocol DeviceInformationSerialNumberCharacteristicDelegate: class {
    func didUpdate(
        modelNumber: Result<DeviceInformationSerialNumber, TypesafeCharacteristicError>,
        for characteristic: DeviceInformationSerialNumberCharacteristic
    )
}

public struct DeviceInformationSerialNumberTransformer: CharacteristicValueTransformer {

    public typealias Value = DeviceInformationSerialNumber

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationSerialNumberTransformer.codingError))
        }
        return .ok(DeviceInformationSerialNumber(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationSerialNumberCharacteristic: TypesafeCharacteristic, TypeIdentifiable {

    public typealias Transformer = DeviceInformationSerialNumberTransformer

    public let transformer: Transformer = .init()

    public static let identifier = Identifier(string: "2A25")

    public weak var delegate: DeviceInformationSerialNumberCharacteristicDelegate? = nil

    public let shadow: ShadowCharacteristic

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }

    public var shouldSubscribeToNotificationsAutomatically: Bool {
        return true
    }
}

extension DeviceInformationSerialNumberCharacteristic: ReadableCharacteristicDelegate {

    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
        ) {
        self.delegate?.didUpdate(modelNumber: self.transform(data: data), for: self)
    }
}

extension DeviceInformationSerialNumberCharacteristic: CharacteristicDataSource {

    public func descriptor(
        shadow: Blues.ShadowDescriptor,
        for characteristic: Characteristic
        ) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
