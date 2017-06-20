//
//  DeviceInformationPnPIDCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct DeviceInformationPnPID {
    public let vendorIDSource: UInt8
    public let vendorID: UInt16
    public let productID: UInt16
    public let productVersion: UInt16
}

public protocol DeviceInformationPnPIDCharacteristicDelegate: class {
    func didUpdate(
        modelNumber: Result<DeviceInformationPnPID, TypedCharacteristicError>,
        for characteristic: DeviceInformationPnPIDCharacteristic
    )
}

public struct DeviceInformationPnPIDTransformer: CharacteristicValueTransformer {
    public typealias Value = DeviceInformationPnPID

    private static let codingError = "Expected UTF-8 encoded string value."

    public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
        let expectedLength = 8
        guard data.count == expectedLength else {
            return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
        }
        return data.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            return .ok(DeviceInformationPnPID(
                vendorIDSource: buffer[6],
                vendorID: UInt16(buffer[4] << 8) & UInt16(buffer[5]),
                productID: UInt16(buffer[2] << 8) & UInt16(buffer[3]),
                productVersion: UInt16(buffer[0] << 8) & UInt16(buffer[1])
            ))
        }
    }

    public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class DeviceInformationPnPIDCharacteristic: Characteristic, TypedCharacteristic, TypeIdentifiable {
    public typealias Transformer = DeviceInformationPnPIDTransformer

    public let transformer: Transformer = .init()

    public static let typeIdentifier = Identifier(string: "2A23")

    public weak var delegate: DeviceInformationPnPIDCharacteristicDelegate? = nil

    open override var shouldSubscribeToNotificationsAutomatically: Bool {
        return false
    }
}

extension DeviceInformationPnPIDCharacteristic: ReadableCharacteristicDelegate {
    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(modelNumber: self.transform(data: data), for: self)
    }
}

extension DeviceInformationPnPIDCharacteristic: CharacteristicDataSource {
    public func descriptor(
        with identifier: Blues.Identifier,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(identifier: identifier, characteristic: characteristic)
    }
}
