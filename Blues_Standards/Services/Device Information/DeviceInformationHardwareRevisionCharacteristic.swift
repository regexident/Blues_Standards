//
//  DeviceInformationHardwareRevisionCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct DeviceInformationHardwareRevision {
    public let string: String
}

extension DeviceInformationHardwareRevision: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public class DeviceInformationHardwareRevisionCharacteristic:
Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "2A27")
    
    open override var name: String? {
        return NSLocalizedString(
            "service.device_information.characteristic.hardware_revision.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Hardware Revision' characteristic"
        )
    }
    
    public weak var delegate: CharacteristicDelegate? = nil
}

extension DeviceInformationHardwareRevisionCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = StringValueCoder
    
    public var decoder: Decoder {
        return .init(encoding: .utf8)
    }
}

extension DeviceInformationHardwareRevisionCharacteristic: StringConvertibleCharacteristicProtocol {}
