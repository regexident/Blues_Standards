//
//  DeviceInformationPnPIDCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
extension DeviceInformation {
    // Poor man's namespace:
    public enum PnPID {}
}

extension DeviceInformation.PnPID {
    public struct Value {
        public let vendorIDSource: UInt8
        public let vendorID: UInt16
        public let productID: UInt16
        public let productVersion: UInt16
    }
}

extension DeviceInformation.PnPID.Value: CustomStringConvertible {
    public var description: String {
        return [
            "vendorIDSource = \(self.vendorIDSource)",
            "vendorID = \(self.vendorID)",
            "productID = \(self.productID)",
            "productVersion = \(self.productVersion)",
        ].joined(separator: ", ")
    }
}

extension DeviceInformation.PnPID {
    public struct Transformer: CharacteristicValueTransformer {
        public typealias Value = DeviceInformation.PnPID.Value

        private static let codingError = "Expected UTF-8 encoded string value."

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            let expectedLength = 8
            guard data.count == expectedLength else {
                return .err(.decodingFailed(message: "Expected data of \(expectedLength) bytes, found \(data.count)."))
            }
            return data.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
                return .ok(Value(
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
}

extension DeviceInformation.PnPID {
    public class Characteristic:
        Blues.Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = DeviceInformation.PnPID.Transformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A23")

        open override var name: String? {
            return NSLocalizedString(
                "service.device_information.characteristic.pnp_id.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'PnP ID' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension DeviceInformation.PnPID.Characteristic: StringConvertibleCharacteristicProtocol {}
