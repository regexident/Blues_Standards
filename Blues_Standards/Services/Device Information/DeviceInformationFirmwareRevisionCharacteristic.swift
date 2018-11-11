//
//  DeviceInformationFirmwareRevisionCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct DeviceInformationFirmwareRevision {
    public let string: String
}

extension DeviceInformationFirmwareRevision: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public class DeviceInformationFirmwareRevisionCharacteristic:
Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "2A26")
    
    open override var name: String? {
        return NSLocalizedString(
            "service.device_information.characteristic.firmware_revision.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Firmware Revision' characteristic"
        )
    }
    
    public weak var delegate: CharacteristicDelegate? = nil
}

extension DeviceInformationFirmwareRevisionCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = StringValueCoder
    
    public var decoder: Decoder {
        return .init(encoding: .utf8)
    }
}

extension DeviceInformationFirmwareRevisionCharacteristic: StringConvertibleCharacteristicProtocol {}
