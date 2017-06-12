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
        modelNumber: Result<DeviceInformationSoftwareRevision, TypesafeCharacteristicError>,
        for characteristic: DeviceInformationSoftwareRevisionCharacteristic
    )
}

public struct DeviceInformationSoftwareRevisionTransformer: CharacteristicValueTransformer {

    public typealias Value = DeviceInformationSoftwareRevision

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationSoftwareRevisionTransformer.codingError))
        }
        return .ok(DeviceInformationSoftwareRevision(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationSoftwareRevisionCharacteristic: TypesafeCharacteristic, TypeIdentifiable {

    public typealias Transformer = DeviceInformationSoftwareRevisionTransformer

    public let transformer: Transformer = .init()

    public static let identifier = Identifier(string: "2A28")

    public weak var delegate: DeviceInformationSoftwareRevisionCharacteristicDelegate? = nil

    public let shadow: ShadowCharacteristic

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }

    public var shouldSubscribeToNotificationsAutomatically: Bool {
        return true
    }
}

extension DeviceInformationSoftwareRevisionCharacteristic: ReadableCharacteristicDelegate {

    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(modelNumber: self.transform(data: data), for: self)
    }
}

extension DeviceInformationSoftwareRevisionCharacteristic: CharacteristicDataSource {

    public func descriptor(
        shadow: Blues.ShadowDescriptor,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
