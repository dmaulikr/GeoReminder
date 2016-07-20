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
        super.viewDidLoad()
        print("MapViewController loaded")
        mapView.mapType = MKMapType.Hybrid
        mapView.zoomEnabled = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
   
    
        retriveNotificationsByOwnerID()
        debugViewAllTrackedLocations()
//        let regions = locationController.locationManager.monitoredRegions as! Set<CLCircularRegion>
//        for r in regions{
//            locationController.locationManager.stopMonitoringForRegion(r)
//        }
        
    }
    
   /*override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
        print ("** viewDidAppear called **")
        if let nots = Notification.loadNotificationsFromUserDefaults(){
            print ("loaded notifs from WillAppear")
            for n in nots{
                 self.drawCirclesOnTheMap(n)
                
            }
        }
    
    }*/
    
    
    
    
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
                
                
                //end block
            }, error: { (fault: Fault!) -> Void in
                print("fServer reported an error: \(fault)")
        })
    }


    override func viewDidDisappear(animated: Bool) {
        print("View Will Dissapear Called")
        print(toSave)
        if(toSave){
            }
        
        // save array of notifications locally
        

    }
   
    
    
    
    
    
    func drawCirclesOnTheMap(ntf: Notification){
    
        let cord = CLLocationCoordinate2D(latitude: ntf.lat,longitude: ntf.lon)
        let circle = MKCircle(centerCoordinate: cord, radius: Double(ntf.notificationRadius) )
        self.mapView.addOverlay(circle)
        self.mapView.delegate = self
    
    }
    
    
    
    
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
        
        
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        
        
        print("Stepper Detected")
    }
    
    func longPress(myPressPoint:UILongPressGestureRecognizer){
        
        if (myPressPoint.state == UIGestureRecognizerState.Began){
        
            print("GESTURE Detected")
            toSave=false
            
            
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
            
            
            //New notification created save to notification list
            //let notification = Notification(Desc: "MyTest1", Title: "2", Rad: 2000, Act: true, Lat :Double(locationCoordinate.latitude),Lon: Double(locationCoordinate.longitude))
           // newNotifications.append(newNote)
            
            // TODO: fix?
            

            toSave=true
            
        
        
        }
               
        
    
    }
    
    func debugViewAllTrackedLocations(){
        let regions = locationController.locationManager.monitoredRegions as! Set<CLCircularRegion>
        for r in regions{
            print("region monitored: \(r.identifier)")
        }
    }
    
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
    
    func saveNotificationsLocally(){
        oldNotifications.appendContentsOf(newNotifications)
        Notification.saveNotificationsToUserDefaults(oldNotifications)
        print("Notifications stored locally")
    }
    
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
    
    func registerNotificationForTracking(ntf: Notification){
        print("tracking for id: \(ntf.id)")
        let center = CLLocationCoordinate2DMake(ntf.lat, ntf.lon)
        let region = CLCircularRegion(center: center, radius: CLLocationDistance( ntf.notificationRadius), identifier: ntf.id)
        
        locationController.locationManager.startMonitoringForRegion(region)
    }
    
    
    
}



