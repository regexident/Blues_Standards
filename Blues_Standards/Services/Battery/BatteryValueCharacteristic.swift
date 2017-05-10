//
//  BatteryValueCharacteristic.swift
//  PeripheralsModule
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public struct BatteryValue {
    /// Normalized battery level (0 == 0%, 100 == 100%)
    public let value: UInt8
}

public protocol BatteryValueCharacteristicDelegate: class {
    func didUpdate(
        value: Result<BatteryValue, TypesafeCharacteristicError>,
        for characteristic: BatteryValueCharacteristic
    )

    func didUpdate(
        notificationState isNotifying: Result<Bool, Error>,
        for characteristic: BatteryValueCharacteristic
    )

    func didDiscover(
        descriptors: Result<[Descriptor], Error>,
        for characteristic: BatteryValueCharacteristic
    )
}

public struct BatteryValueTransformer: CharacteristicValueTransformer {

    public typealias Value = BatteryValue

    private static let codingError = "Expected value within 0 and 100 (inclusive)."

    public func transform(data: Data) -> Result<Value, TypesafeCharacteristicError> {
        let expectedLength = 1
        guard data.count == expectedLength else {
            return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
        }
        return data.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            let byte = buffer[0]
            if byte <= 100 {
                return .ok(BatteryValue(value: byte))
            } else {
                return .err(.decodingFailed(message: BatteryValueTransformer.codingError))
            }
        }
    }

    public func transform(value: Value) -> Result<Data, TypesafeCharacteristicError> {
        return .err(.transformNotImplemented)
    }
}

public class BatteryValueCharacteristic: TypesafeCharacteristic, TypeIdentifiable {

    public typealias Transformer = BatteryValueTransformer

    public let transformer: Transformer = .init()

    public static let identifier = Identifier(string: "2A19")

    public weak var delegate: BatteryValueCharacteristicDelegate? = nil

    public let shadow: ShadowCharacteristic

    public required init(shadow: ShadowCharacteristic) {
        self.shadow = shadow
    }

    public var shouldSubscribeToNotificationsAutomatically: Bool {
        return true
    }
}

extension BatteryValueCharacteristic: ReadableCharacteristicDelegate {

    public func didUpdate(
        data: Result<Data, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(value: self.transform(data: data), for: self)
    }
}

extension BatteryValueCharacteristic: NotifyableCharacteristicDelegate {

    public func didUpdate(
        notificationState isNotifying: Result<Bool, Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didUpdate(notificationState: isNotifying, for: self)
    }
}

extension BatteryValueCharacteristic: DescribableCharacteristicDelegate {

    public func didDiscover(
        descriptors: Result<[Descriptor], Error>,
        for characteristic: Characteristic
    ) {
        self.delegate?.didDiscover(descriptors: descriptors, for: self)
    }
}

extension BatteryValueCharacteristic: CharacteristicDataSource {

    public func descriptor(
        shadow: Blues.ShadowDescriptor,
        for characteristic: Characteristic
    ) -> Descriptor {
        return DefaultDescriptor(shadow: shadow)
    }
}
