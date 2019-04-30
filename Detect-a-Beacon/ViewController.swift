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
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    let circle = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        circle.frame.size = CGSize(width: 256, height: 256)
        circle.layer.cornerRadius = 128
        circle.backgroundColor = .darkGray
        circle.center.x = view.center.x
        circle.center.y = view.center.y
        view.addSubview(circle)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.circle.backgroundColor = .blue
                self.animateCircle(scale: 0.25)
                self.distanceReading.text = "FAR"
                
            case .near:
                self.circle.backgroundColor = .orange
                self.animateCircle(scale: 0.5)
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.circle.backgroundColor = .red
                self.animateCircle(scale: 1.0)
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.circle.backgroundColor = .darkGray
                self.animateCircle(scale: 0.001)
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func animateCircle(scale: CGFloat) {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: {
            self.circle.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
}

