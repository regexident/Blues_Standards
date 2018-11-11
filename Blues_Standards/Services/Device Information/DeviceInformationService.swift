//
//  DeviceInformationService.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

open class DeviceInformationService: Blues.Service, DelegatedServiceProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "180A")
    
    open override var name: String? {
        return NSLocalizedString(
            "service.device_information.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Device Information' service"
        )
    }
    
    weak public var delegate: ServiceDelegate?
}

extension DeviceInformationService: ServiceDataSource {
    public func characteristic(with identifier: Identifier, for service: Service) -> Characteristic {
        switch identifier {
        case DeviceInformationManufacturerNameCharacteristic.typeIdentifier:
            return DeviceInformationManufacturerNameCharacteristic(identifier: identifier, service: service)
        case DeviceInformationModelNumberCharacteristic.typeIdentifier:
            return DeviceInformationModelNumberCharacteristic(identifier: identifier, service: service)
        case DeviceInformationSerialNumberCharacteristic.typeIdentifier:
            return DeviceInformationSerialNumberCharacteristic(identifier: identifier, service: service)
        case DeviceInformationHardwareRevisionCharacteristic.typeIdentifier:
            return DeviceInformationHardwareRevisionCharacteristic(identifier: identifier, service: service)
        case DeviceInformationFirmwareRevisionCharacteristic.typeIdentifier:
            return DeviceInformationFirmwareRevisionCharacteristic(identifier: identifier, service: service)
        case DeviceInformationSoftwareRevisionCharacteristic.typeIdentifier:
            return DeviceInformationSoftwareRevisionCharacteristic(identifier: identifier, service: service)
        case DeviceInformationSystemIDCharacteristic.typeIdentifier:
            return DeviceInformationSystemIDCharacteristic(identifier: identifier, service: service)
        case DeviceInformationPnPIDCharacteristic.typeIdentifier:
            return DeviceInformationPnPIDCharacteristic(identifier: identifier, service: service)
        default:
            return DefaultCharacteristic(identifier: identifier, service: service)
        }
    }
}
