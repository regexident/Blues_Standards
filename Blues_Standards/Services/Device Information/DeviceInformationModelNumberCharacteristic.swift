//
//  DeviceInformationModelNumberCharacteristic.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public struct DeviceInformationModelNumber {
    public let string: String
}

extension DeviceInformationModelNumber: CustomStringConvertible {
    public var description: String {
        return self.string
    }
}

public class DeviceInformationModelNumberCharacteristic:
Characteristic, DelegatedCharacteristicProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "2A24")
    
    public weak var delegate: CharacteristicDelegate? = nil
    
    public override init(identifier: Identifier, service: Service) {
        super.init(identifier: identifier, service: service)
        
        self.name = NSLocalizedString(
            "service.device_information.characteristic.model_number.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Model Number' characteristic"
        )
    }
}

extension DeviceInformationModelNumberCharacteristic: TypedReadableCharacteristicProtocol {
    public typealias Decoder = StringValueCoder
    
    public var decoder: Decoder {
        return .init(encoding: .utf8)
    }
}

extension DeviceInformationModelNumberCharacteristic: StringConvertibleCharacteristicProtocol {}
