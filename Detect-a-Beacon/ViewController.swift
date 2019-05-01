//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Michele Galvagno on 29/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var beaconIdentifier: UILabel!
    @IBOutlet var distanceReading: UILabel!
    
    var locationManager: CLLocationManager?
    var isAlertShown = false
    
    let beacon1 = Beacon(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "First beacon", isAlertShown: false)
    let beacon2 = Beacon(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, major: 234, minor: 567, identifier: "Second beacon", isAlertShown: false)
    let beacon3 = Beacon(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!, major: 345, minor: 678, identifier: "Third beacon", isAlertShown: false)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        beaconIdentifier.text = "No beacon detected"
    }
    
    // Ask for the user's permission to track her location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    // Look for beacons
    func startScanning() {
        let beacons: [Beacon] = [beacon1, beacon2, beacon3]
        for beacon in beacons {
            let beaconRegion = CLBeaconRegion(proximityUUID: beacon.uuid, major: beacon.major, minor: beacon.minor, identifier: beacon.identifier)
            
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(in: beaconRegion)
        }
    }
    
    // Update the view depending on the distance from the beacon
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconIdentifier.text = "No beacon detected"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                    self.isAlertShown = false
                })
            }
        }
    }
    
    // Do something if a beacon is found
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            beaconIdentifier.text = region.identifier
            update(distance: beacon.proximity)
            
            if isAlertShown == false {
                let beaconAC = UIAlertController(title: "\(region.identifier) detected!", message: nil, preferredStyle: .alert)
                beaconAC.addAction(UIAlertAction(title: "OK", style: .default))
                isAlertShown = true
                present(beaconAC, animated: true)
            }
        }
    }
}
