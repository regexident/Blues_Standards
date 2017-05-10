//
//  BatteryService.swift
//  PeripheralsModule
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public class BatteryService: Service, TypeIdentifiable {

    public static let identifier = Identifier(string: "180F")

    public let shadow: ShadowService

    weak public var delegate: ServiceDelegate?

    public required init(shadow: ShadowService) {
        self.shadow = shadow
    }
    
    open var automaticallyDiscoveredCharacteristics: [Identifier]? {
        return [
            BatteryValueCharacteristic.identifier
        ]
    }
}

extension BatteryService: ServiceDelegate {

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

extension BatteryService: ServiceDataSource {

    public func characteristic(shadow: ShadowCharacteristic, for service: Service) -> Characteristic {
        switch shadow.identifier {
        case BatteryValueCharacteristic.identifier:
            return BatteryValueCharacteristic(shadow: shadow)
        default:
            return DefaultCharacteristic(shadow: shadow)
        }
    }
}
