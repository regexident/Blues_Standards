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

open class BatteryService: DelegatedService {

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

extension BatteryService: ServiceDataSource {

    public func characteristic(shadow: ShadowCharacteristic, forService service: Service) -> Characteristic {
        switch shadow.identifier {
        case BatteryValueCharacteristic.identifier:
            return BatteryValueCharacteristic(shadow: shadow)
        default:
            return DefaultCharacteristic(shadow: shadow)
        }
    }
}
