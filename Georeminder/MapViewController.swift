//
//  MapViewController.swift
//  GeoReminder
//
//  Created by Admin on 11.07.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapViewController : UIViewController , UIGestureRecognizerDelegate, MKMapViewDelegate, NotificationControllerDelegate , UIPopoverPresentationControllerDelegate {
    
    var backendless = Backendless.sharedInstance()
    var appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var locationController: CoreLocationController!
    var newNotifications: [Notification] = []
    var oldNotifications: [Notification] = []
    var newNote : Notification!
    var locationCoordinate : CLLocationCoordinate2D!
    var toSave = true
    
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    override func viewDidLoad() {
        newNote = Notification()
        locationController = appDel.coreLocationController!
        locationController.mapview = self
        
        super.viewDidLoad()
        print("MapViewController loaded")
        mapView.mapType = MKMapType.Hybrid
        mapView.zoomEnabled = true
        mapView.showsUserLocation = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
        
        
        retriveNotificationsByOwnerID()
        disableAllRegionsMonitored()
        debugViewAllTrackedLocations()
        
        
        
    }
    
    func disableAllRegionsMonitored(){
        let regions = locationController.locationManager.monitoredRegions as! Set<CLCircularRegion>
        for r in regions{
            locationController.locationManager.stopMonitoringForRegion(r)
        }
    }
    
    func reEnableRegionsForMonitoring(){
        for i in oldNotifications{
            if i.isActive{
                registerNotificationForTracking(i)
            }
        }
    }
    
    //To zoom when location loaded
    func ZoomToLocation(){
        
        guard let latitude:CLLocationDegrees = (locationController.locationManager.location?.coordinate.latitude)! else {return}
        
        
        guard let longitude:CLLocationDegrees = (locationController.locationManager.location?.coordinate.longitude)! else {return}
        
        
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: false)
        
        
    }
    
    //load from Backendless DB
    
    func retriveNotificationsByOwnerID() {
        let n = backendless.userService.currentUser.getProperty("ownerId") as! String
        let whereClause = "ownerId = '"+n+"'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        backendless.data.of(Notification.ofClass()).find(dataQuery,
            response: { (result: BackendlessCollection!) -> Void in
                //start block
                
                for ntf in result.data as! [Notification]{
                    print (ntf.lat)
                    if(ntf.isActive){
                        self.drawCirclesOnTheMap(ntf)
                    }
                    
                    
                    self.oldNotifications.append(ntf)
                    
                }
                
                self.reEnableRegionsForMonitoring()
                
                //end block
            }, error: { (fault: Fault!) -> Void in
                print("fServer reported an error: \(fault)")
        })
    }
    
    
    
    //drawe the circle on the map
    
    func drawCirclesOnTheMap(ntf: Notification){
        
        let cord = CLLocationCoordinate2D(latitude: ntf.lat,longitude: ntf.lon)
        let circle = MKCircle(centerCoordinate: cord, radius: Double(ntf.notificationRadius) )
        self.mapView.addOverlay(circle)
        self.mapView.delegate = self
        
    }
    
    
    //save to the Backendles DB
    
    func storeNotificationsToBackEndless(){
        let dataStore = backendless.data.of(Notification.ofClass())
        
        for note in newNotifications{
            
            dataStore.save(
                note,
                response: { (result: AnyObject!) -> Void in
                    let obj = result as! Notification
                    print("Notification has been saved: \(obj.notificationTitle)")
                },
                error: { (fault: Fault!) -> Void in
                    print("fServer reported an error: \(fault)")
            })}
        
        
        
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        //for testing purposes only
        
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        
        //for testing purposes only
        print("Stepper Detected")
    }
    
    
    //gesture action
    func longPress(myPressPoint:UILongPressGestureRecognizer){
        
        if (myPressPoint.state == UIGestureRecognizerState.Began){
            
            print("GESTURE Detected")
            
            
            //prepare popover segue
            let savingsInformationViewController = storyboard?.instantiateViewControllerWithIdentifier("segueNewNot1") as! NewNotificationViewController
            savingsInformationViewController.delegate=self;
            savingsInformationViewController.notification = newNote
            
            savingsInformationViewController.modalPresentationStyle = .Popover
            if let popoverController = savingsInformationViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                
                popoverController.permittedArrowDirections = .Any
                popoverController.delegate = self
            }
            presentViewController(savingsInformationViewController, animated: true, completion: nil)
            
            
            
            let touchLocation = myPressPoint.locationInView(mapView)
            locationCoordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
            
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            newNote.lat = Double(locationCoordinate.latitude)
            newNote.lon = Double(locationCoordinate.longitude)
            
            
            
            
        }
        
        
        
    }
    
    
    //for debuging
    func debugViewAllTrackedLocations(){
        let regions = locationController.locationManager.monitoredRegions as! Set<CLCircularRegion>
        for r in regions{
            print("region monitored: \(r.identifier)")
        }
    }
    
    
    //callback from protocol
    func saveNotification(notification: Notification) {
        newNote = notification
        newNotifications.append(newNote)
        let circle = MKCircle(centerCoordinate: locationCoordinate, radius: Double(newNote.notificationRadius))
        mapView.addOverlay(circle)
        mapView.delegate = self
        registerNotificationForTracking(newNote)    //register for track
        saveNotificationsLocally()
        storeNotificationsToBackEndless()
        
        print(newNote.notificationRadius)
        
    }
    
    //save to file
    
    func saveNotificationsLocally(){
        oldNotifications.appendContentsOf(newNotifications)
        Notification.saveNotificationsToUserDefaults(oldNotifications)
        print("Notifications stored locally")
    }
    
    
    //prepare circle rendering
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKindOfClass(MKCircle){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.redColor().colorWithAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.blueColor()
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    //register notification for tracking service.
    func registerNotificationForTracking(ntf: Notification){
        print("tracking for id: \(ntf.id)")
        let center = CLLocationCoordinate2DMake(ntf.lat, ntf.lon)
        let region = CLCircularRegion(center: center, radius: CLLocationDistance( ntf.notificationRadius), identifier: ntf.id)
        
        locationController.locationManager.startMonitoringForRegion(region)
    }
    
    
    
}



