//
//  DeviceInformationSystemIDCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct DeviceInformationSystemID {
    public let manufacturerIdentifier: UInt64
    public let organizationallyUniqueIdentifier: UInt32
}

public protocol DeviceInformationSystemIDCharacteristicDelegate: class {
    func didUpdate(
        modelNumber: Result<DeviceInformationSystemID, TypesafeCharacteristicError>,
        for characteristic: DeviceInformationSystemIDCharacteristic
    )
}

public struct DeviceInformationSystemIDTransformer: CharacteristicValueTransformer {

    public typealias Value = DeviceInformationSystemID

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        let expectedLength = 8
        guard data.count == expectedLength else {
            return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
        }
        return data.withUnsafeBytes { (buffer: UnsafePointer<UInt64>) in
            let bytes = UInt64(bigEndian: buffer[0])
            return .ok(DeviceInformationSystemID(
                manufacturerIdentifier: bytes & (~0 >> 24),
                organizationallyUniqueIdentifier: UInt32(bytes >> 40)
            ))
        }
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationSystemIDCharacteristic: TypesafeCharacteristic, TypeIdentifiable {

    public typealias Transformer = DeviceInformationSystemIDTransformer

    public let transformer: Transformer = .init()

    public static let identifier = Identifier(string: "2A23")

    public weak var delegate: DeviceInformationSystemIDCharacteristicDelegate? = nil

    public let shadow: ShadowCharacteristic

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }

    public var shouldSubscribeToNotificationsAutomatically: Bool {
        return true
    }
}

extension DeviceInformationSystemIDCharacteristic: ReadableCharacteristicDelegate {

    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(modelNumber: self.transform(data: data), for: self)
    }
}

extension DeviceInformationSystemIDCharacteristic: CharacteristicDataSource {

    public func descriptor(
        shadow: Blues.ShadowDescriptor,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
