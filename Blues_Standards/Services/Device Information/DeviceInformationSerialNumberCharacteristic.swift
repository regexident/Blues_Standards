//
//  DeviceInformationSerialNumberCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct DeviceInformationSerialNumber {
    public let string: String
}

extension DeviceInformationSerialNumber: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public class DeviceInformationSerialNumberCharacteristic:
Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "2A25")
    
    public weak var delegate: CharacteristicDelegate? = nil
    
    public override init(identifier: Identifier, service: ServiceProtocol) {
        super.init(identifier: identifier, service: service)
        
        self.name = NSLocalizedString(
            "service.device_information.characteristic.serial_number.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Serial Number' characteristic"
        )
    }
}

extension DeviceInformationSerialNumberCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = StringValueCoder
    
    public var decoder: Decoder {
        return .init(encoding: .utf8)
    }
}

extension DeviceInformationSerialNumberCharacteristic: StringConvertibleCharacteristicProtocol {}
