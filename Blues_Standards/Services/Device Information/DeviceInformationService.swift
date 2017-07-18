//
//  DeviceInformationService.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

// Poor man's namespace:
public enum DeviceInformation {}

extension DeviceInformation {
    open class Service: Blues.Service, DelegatedServiceProtocol, TypeIdentifiable {
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
}

extension DeviceInformation.Service: ServiceDataSource {
    public func characteristic(with identifier: Identifier, for service: Service) -> Characteristic {
        switch identifier {
        case DeviceInformation.ManufacturerNameCharacteristic.typeIdentifier:
            return DeviceInformation.ManufacturerNameCharacteristic(identifier: identifier, service: service)
        case DeviceInformation.ModelNumberCharacteristic.typeIdentifier:
            return DeviceInformation.ModelNumberCharacteristic(identifier: identifier, service: service)
        case DeviceInformation.SerialNumberCharacteristic.typeIdentifier:
            return DeviceInformation.SerialNumberCharacteristic(identifier: identifier, service: service)
        case DeviceInformation.HardwareRevisionCharacteristic.typeIdentifier:
            return DeviceInformation.HardwareRevisionCharacteristic(identifier: identifier, service: service)
        case DeviceInformation.FirmwareRevisionCharacteristic.typeIdentifier:
            return DeviceInformation.FirmwareRevisionCharacteristic(identifier: identifier, service: service)
        case DeviceInformation.SoftwareRevisionCharacteristic.typeIdentifier:
            return DeviceInformation.SoftwareRevisionCharacteristic(identifier: identifier, service: service)
        case DeviceInformation.SystemIDCharacteristic.typeIdentifier:
            return DeviceInformation.SystemIDCharacteristic(identifier: identifier, service: service)
        default:
            return DefaultCharacteristic(identifier: identifier, service: service)
        }
    }
}
