//
//  DeviceInformationSerialNumberCharacteristic.swift
//  Blues_Standards
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

public struct DeviceInformationSerialNumberTransformer: CharacteristicValueTransformer {
    public typealias Value = DeviceInformationSerialNumber

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        guard let string = String(data: data, encoding: .utf8) else {
            return .err(.decodingFailed(message: DeviceInformationSerialNumberTransformer.codingError))
        }
        return .ok(DeviceInformationSerialNumber(string: string))
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationSerialNumberCharacteristic:
    Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
    public typealias Transformer = DeviceInformationSerialNumberTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A25")

    public weak var delegate: CharacteristicDelegate? = nil

    open override var shouldSubscribeToNotificationsAutomatically: Bool {
        return false
    }
}
