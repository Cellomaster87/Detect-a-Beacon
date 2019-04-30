//
//  Beacon.swift
//  Detect-a-Beacon
//
//  Created by Michele Galvagno on 30/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import CoreLocation
import Foundation

class Beacon {
    let uuid: UUID
    let major: CLBeaconMajorValue
    let minor: CLBeaconMinorValue
    let identifier: String
    
    let isAlertShown: Bool
    
    init(uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String, isAlertShown: Bool) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.identifier = identifier
        self.isAlertShown = isAlertShown
    }
}
