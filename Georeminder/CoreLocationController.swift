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
    var mapview :MapViewController?
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter  = 5 // Must move at least 5m
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
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
        if (mapview != nil){
            mapview?.ZoomToLocation()
        }
        
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
        var ntf:Notification!
        let notifications = Notification.loadNotificationsFromUserDefaults()
        for n in notifications!{
            if n.id == region.identifier{
                ntf = n
                break
            }
        }
        
        
        let notification = UILocalNotification()
        notification.alertBody = "\(ntf.notificationDescription)" // text that will be displayed in the notification
        notification.alertAction = "view" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate()  // fired now
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": ntf.notificationTitle!, "UUID": ntf.id] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exited: \(region.identifier)")
       
    }
}
