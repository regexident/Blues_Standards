//
//  DeviceInformationFirmwareRevisionCharacteristic.swift
//  Blues_Standards
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

public struct DeviceInformationFirmwareRevisionTransformer: CharacteristicValueTransformer {
    public typealias Value = DeviceInformationFirmwareRevision

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationFirmwareRevisionTransformer.codingError))
        }
        return .ok(DeviceInformationFirmwareRevision(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationFirmwareRevisionCharacteristic:
    Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
    public typealias Transformer = DeviceInformationFirmwareRevisionTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A26")

    public weak var delegate: CharacteristicDelegate? = nil

    open override var shouldSubscribeToNotificationsAutomatically: Bool {
        return false
    }
}
