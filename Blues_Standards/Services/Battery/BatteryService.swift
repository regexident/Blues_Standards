//
//  BatteryService.swift
//  Blues_Standards
//
//  Created by Vincent Esche on 18/01/2017.
//  Copyright © 2017 NWTN Berlin. All rights reserved.
//

import Foundation

import Blues
// Poor man's namespace:
public enum Battery {}

extension Battery {
    public class Service: Blues.Service, DelegatedServiceProtocol, TypeIdentifiable {
        public static let typeIdentifier = Identifier(string: "180F")

        open override var name: String? {
            return NSLocalizedString(
                "service.battery.name",
                bundle: Bundle(for: type(of: self)),
                comment: "Name of 'Battery' service"
            )
        }

        weak public var delegate: ServiceDelegate?
    }
}

extension Battery.Service: ServiceDataSource {
    public func characteristic(with identifier: Identifier, for service: Service) -> Characteristic {
        switch identifier {
        case Battery.Level.Characteristic.typeIdentifier:
            return Battery.Level.Characteristic(identifier: identifier, service: service)
        default:
            return DefaultCharacteristic(identifier: identifier, service: service)
        }
    }
}
