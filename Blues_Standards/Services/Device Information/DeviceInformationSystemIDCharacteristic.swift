//
//  DeviceInformationSystemIDCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct DeviceInformationSystemID {
    public let string: String
}

extension DeviceInformationSystemID: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public class DeviceInformationSystemIDCharacteristic:
Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
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

extension DeviceInformationSystemIDCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = StringValueCoder
    
    public var decoder: Decoder {
        return .init(encoding: .utf8)
    }
}

extension DeviceInformationSystemIDCharacteristic: StringConvertibleCharacteristicProtocol {}
