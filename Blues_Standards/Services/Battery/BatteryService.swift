//
//  BatteryService.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues

public class BatteryService: Blues.Service, DelegatedServiceProtocol, TypeIdentifiable {
    public static let typeIdentifier = Identifier(string: "180F")
    
    weak public var delegate: ServiceDelegate?
    
    public override init(identifier: Identifier, peripheral: Peripheral) {
        super.init(identifier: identifier, peripheral: peripheral)
        
        self.name = NSLocalizedString(
            "service.battery.name",
            bundle: Bundle(for: type(of: self)),
            comment: "Name of 'Battery' service"
        )
    }
}

extension BatteryService: ServiceDataSource {
    public func characteristic(with identifier: Identifier, for service: Service) -> Characteristic {
        switch identifier {
        case BatteryLevelCharacteristic.typeIdentifier:
            return BatteryLevelCharacteristic(identifier: identifier, service: service)
        default:
            return DefaultCharacteristic(identifier: identifier, service: service)
        }
    }
}
