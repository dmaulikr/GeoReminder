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
            self.locationManager.startUpdatingLocation()  // start tracking the location if authorized
            break
            
        case .Denied:
            print(".Denied")
             self.locationManager.stopUpdatingLocation()  // stop tracking location if user denied the app to use locations
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
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered: \(region.identifier)")
        
        
        let notification = UILocalNotification()
        notification.alertBody = "Entered \(region.identifier)" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate()  // fired now
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": "title", "UUID": "123"] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exited: \(region.identifier)")
    }
}
