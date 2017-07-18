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
        case DeviceInformation.ManufacturerName.Characteristic.typeIdentifier:
            return DeviceInformation.ManufacturerName.Characteristic(identifier: identifier, service: service)
        case DeviceInformation.ModelNumber.Characteristic.typeIdentifier:
            return DeviceInformation.ModelNumber.Characteristic(identifier: identifier, service: service)
        case DeviceInformation.SerialNumber.Characteristic.typeIdentifier:
            return DeviceInformation.SerialNumber.Characteristic(identifier: identifier, service: service)
        case DeviceInformation.HardwareRevision.Characteristic.typeIdentifier:
            return DeviceInformation.HardwareRevision.Characteristic(identifier: identifier, service: service)
        case DeviceInformation.FirmwareRevision.Characteristic.typeIdentifier:
            return DeviceInformation.FirmwareRevision.Characteristic(identifier: identifier, service: service)
        case DeviceInformation.SoftwareRevision.Characteristic.typeIdentifier:
            return DeviceInformation.SoftwareRevision.Characteristic(identifier: identifier, service: service)
        case DeviceInformation.SystemID.Characteristic.typeIdentifier:
            return DeviceInformation.SystemID.Characteristic(identifier: identifier, service: service)
        case DeviceInformation.PnPID.Characteristic.typeIdentifier:
            return DeviceInformation.PnPID.Characteristic(identifier: identifier, service: service)
        default:
            return DefaultCharacteristic(identifier: identifier, service: service)
        }
    }
}
