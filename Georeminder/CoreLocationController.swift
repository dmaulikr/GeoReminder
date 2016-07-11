//
//  CoreLocationController.swift
//  Georeminder
//
//  Created by Admin on 1107..16.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import UIKit
import CoreLocation

class CoreLocationController: NSObject, CLLocationManagerDelegate  {
    var locationManager:CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter  = 5 // Must move at least 5m
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        self.locationManager.requestAlwaysAuthorization()
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            print(".NotDetermined")
            break
            
        case .Authorized:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
            
        case .Denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // this method is called for every location update
        
        let location = locations.last! as CLLocation
        
        print("didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        
    }
}
