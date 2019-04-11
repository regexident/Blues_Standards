//
//  DeviceInformationPnPIDCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct DeviceInformationPnPID {
    public let vendorIDSource: UInt8
    public let vendorID: UInt16
    public let productID: UInt16
    public let productVersion: UInt16
}

extension DeviceInformationPnPID: CustomStringConvertible {
    public var description: String {
        return [
            "vendorIDSource = \(self.vendorIDSource)",
            "vendorID = \(self.vendorID)",
            "productID = \(self.productID)",
            "productVersion = \(self.productVersion)",
            ].joined(separator: ", ")
    }
}

public struct DeviceInformationPnPIDDecoder: ValueDecoder {
    public typealias Value = DeviceInformationPnPID
    
    public typealias Input = Data
    
    public func decode(_ input: Input) -> Result<Value, Blues.DecodingError> {
        let expectedLength = 8
        guard input.count == expectedLength else {
            let message = "Expected data of \(expectedLength) bytes, found \(input.count)."
            return .failure(.init(message: message))
        }
        return input.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            return .success(Value(
                vendorIDSource: buffer[6],
                vendorID: UInt16(buffer[4] << 8) & UInt16(buffer[5]),
                productID: UInt16(buffer[2] << 8) & UInt16(buffer[3]),
                productVersion: UInt16(buffer[0] << 8) & UInt16(buffer[1])
            ))
        }
    }
}

public class DeviceInformationPnPIDCharacteristic:
Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "2A23")
    
    public weak var delegate: CharacteristicDelegate? = nil
    
    public override init(identifier: Identifier, service: ServiceProtocol) {
        super.init(identifier: identifier, service: service)
        
        self.name = NSLocalizedString(
            "service.device_information.characteristic.pnp_id.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'PnP ID' characteristic"
        )
    }
}

extension DeviceInformationPnPIDCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = DeviceInformationPnPIDDecoder
    
    public var decoder: Decoder {
        return .init()
    }
}

extension DeviceInformationPnPIDCharacteristic: StringConvertibleCharacteristicProtocol {}
