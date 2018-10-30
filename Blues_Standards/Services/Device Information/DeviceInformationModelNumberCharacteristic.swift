//
//  DeviceInformationModelNumberCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
extension DeviceInformation {
    // Poor man's namespace:
    public enum ModelNumber {}
}

extension DeviceInformation.ModelNumber {
    public struct Value {
        public let string: String
    }
}

extension DeviceInformation.ModelNumber.Value: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

extension DeviceInformation.ModelNumber {
    public struct Transformer: CharacteristicValueTransformer {
        public typealias Value = DeviceInformation.ModelNumber.Value

        enum Error: Swift.Error {
            case unableToDecodeString(data: Data)
        }

        public func transform(data: Data) -> Result<Value, TypedCharacteristicError> {
            guard let string = String(data: data, encoding: .utf8) else {
                return .err(.decodingFailed(error: Error.unableToDecodeString(data: data)))
            }
            return .ok(Value(string: string))
        }

        public func transform(value: Value) -> Result<Data, TypedCharacteristicError> {
            return .err(.transformNotImplemented)
        }
    }
}

extension DeviceInformation.ModelNumber {
    public class Characteristic:
        Blues.Characteristic, DelegatedCharacteristicProtocol, TypedCharacteristicProtocol, TypeIdentifiable {
        public typealias Transformer = DeviceInformation.ModelNumber.Transformer

        public let transformer: Transformer = .init()

        public static let typeIdentifier = Identifier(string: "2A24")

        open override var name: String? {
            return NSLocalizedString(
                "service.device_information.characteristic.model_number.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'Model Number' characteristic"
            )
        }

        public weak var delegate: CharacteristicDelegate? = nil
    }
}

extension DeviceInformation.ModelNumber.Characteristic: StringConvertibleCharacteristicProtocol {}
