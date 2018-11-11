//
//  DeviceInformationManufacturerNameCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct DeviceInformationManufacturerName {
    public let string: String
}

extension DeviceInformationManufacturerName: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public class DeviceInformationManufacturerNameCharacteristic:
Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "2A29")
    
    open override var name: String? {
        return NSLocalizedString(
            "service.device_information.characteristic.manufacturer_name.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Manufacturer Name' characteristic"
        )
    }
    
    public weak var delegate: CharacteristicDelegate? = nil
}

extension DeviceInformationManufacturerNameCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = StringValueCoder
    
    public var decoder: Decoder {
        return .init(encoding: .utf8)
    }
}

extension DeviceInformationManufacturerNameCharacteristic: StringConvertibleCharacteristicProtocol {}
