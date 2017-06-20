//
//  BatteryService.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
import Result

public class BatteryService: Service, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "180F")

    weak public var delegate: ServiceDelegate?

    open override var automaticallyDiscoveredCharacteristics: [Identifier]? {
        return [
            BatteryValueCharacteristic.typeIdentifier
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
    public func characteristic(with identifier: Identifier, for service: Service) -> Characteristic {
        switch identifier {
        case BatteryValueCharacteristic.typeIdentifier:
            return BatteryValueCharacteristic(identifier: identifier, service: service)
        default:
            return DefaultCharacteristic(identifier: identifier, service: service)
        }
    }
}
