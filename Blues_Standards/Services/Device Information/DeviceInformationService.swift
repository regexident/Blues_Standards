//
//  DeviceInformationService.swift
//  PeripheralsModule
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

open class DeviceInformationService: Service {

    public static let identifier = Identifier(string: "180A")

    public let shadow: ShadowService

    weak public var delegate: ServiceDelegate?

    public required init(shadow: ShadowService) {
        self.shadow = shadow
    }
    
    open var automaticallyDiscoveredCharacteristics: [Identifier]? {
        return [
            DeviceInformationManufacturerNameCharacteristic.identifier,
            DeviceInformationModelNumberCharacteristic.identifier,
            DeviceInformationSerialNumberCharacteristic.identifier,
            DeviceInformationHardwareRevisionCharacteristic.identifier,
            DeviceInformationFirmwareRevisionCharacteristic.identifier,
            DeviceInformationSoftwareRevisionCharacteristic.identifier,
            DeviceInformationSystemIDCharacteristic.identifier,
        ]
    }
}

extension DeviceInformationService: ServiceDelegate {

    public func didDiscover(
        includedServices: Result<[Service], Error>,
        for service: Service
    ) {
        self.delegate?.didDiscover(includedServices: includedServices, for: service)
    }

    public func didDiscover(
        characteristics: Result<[Characteristic], Error>,
        for service: Service
    ) {
        self.delegate?.didDiscover(characteristics: characteristics, for: service)
    }
}

extension DeviceInformationService: ServiceDataSource {

    public func characteristic(shadow: ShadowCharacteristic, for service: Service) -> Characteristic {
        switch shadow.identifier {
        case DeviceInformationManufacturerNameCharacteristic.identifier:
            return DeviceInformationManufacturerNameCharacteristic(shadow: shadow)
        case DeviceInformationModelNumberCharacteristic.identifier:
            return DeviceInformationModelNumberCharacteristic(shadow: shadow)
        case DeviceInformationSerialNumberCharacteristic.identifier:
            return DeviceInformationSerialNumberCharacteristic(shadow: shadow)
        case DeviceInformationHardwareRevisionCharacteristic.identifier:
            return DeviceInformationHardwareRevisionCharacteristic(shadow: shadow)
        case DeviceInformationFirmwareRevisionCharacteristic.identifier:
            return DeviceInformationFirmwareRevisionCharacteristic(shadow: shadow)
        case DeviceInformationSoftwareRevisionCharacteristic.identifier:
            return DeviceInformationSoftwareRevisionCharacteristic(shadow: shadow)
        case DeviceInformationSystemIDCharacteristic.identifier:
            return DeviceInformationSystemIDCharacteristic(shadow: shadow)
        default:
            return DefaultCharacteristic(shadow: shadow)
        }
    }
}
