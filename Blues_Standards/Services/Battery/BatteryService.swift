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

public class BatteryService: Service, DelegatedServiceProtocol, TypeIdentifiable {
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
// MARK: - Battery Namespace public enum Battery {}  extension Battery {     public class Service: Blues.Service, DelegatedServiceProtocol, TypeIdentifiable {         public static let typeIdentifier = Identifier(string: "180F")          open override var name: String? {             return NSLocalizedString(                 "service.battery.name",                 bundle: Bundle(for: type(of: self)),                 comment: "Name of 'Battery' service"             )         }          weak public var delegate: ServiceDelegate?     } } 
