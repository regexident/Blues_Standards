//
//  DeviceInformationSystemIDCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
extension DeviceInformation {
    // Poor man's namespace:
    public enum SystemID {}
}

extension DeviceInformation.SystemID {
    public struct Value {
        public let manufacturerIdentifier: UInt64
        public let organizationallyUniqueIdentifier: UInt32
    }
}

extension DeviceInformation.SystemID.Value: CustomStringConvertible {
    public var description: String {
        return [
            "manufacturerIdentifier = \(self.manufacturerIdentifier)",
            "organizationallyUniqueIdentifier = \(self.organizationallyUniqueIdentifier)",
        ].joined(separator: ", ")
    }
}

extension DeviceInformation.SystemID {
    public struct Transformer: CharacteristicValueTransformer {
        public typealias Value = DeviceInformation.SystemID.Value

        enum Error: Swift.Error {
            case wrongDataSize(expected: Int, received: Int)
        }
        
        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            let expectedLength = 8
            
            guard data.count == expectedLength else {
                return .err(.decodingFailed(error: Error.wrongDataSize(expected: expectedLength, received: data.count)))
            }
            
            return data.withUnsafeBytes { (buffer: UnsafePointer<UInt64>) in
                let bytes = UInt64(bigEndian: buffer[0])
                return .ok(Value(
                    manufacturerIdentifier: bytes & (~0 >> 24),
                    organizationallyUniqueIdentifier: UInt32(bytes >> 40)
                ))
            }
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }

    public class Characteristic:
        Blues.Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = DeviceInformation.SystemID.Transformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A23")

        open override var name: String? {
            return NSLocalizedString(
                "service.device_information.characteristic.system_id.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'System ID' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension DeviceInformation.SystemID.Characteristic: StringConvertibleCharacteristicProtocol {}
