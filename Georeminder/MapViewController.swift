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

class MapViewController : UIViewController , UIGestureRecognizerDelegate, MKMapViewDelegate{
    var backendless = Backendless.sharedInstance()
    var appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var locationController: CoreLocationController!
    var newNotifications: [Notification] = []
    var oldNotifications: [Notification] = []
  
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var mapView: MKMapView!
    

    
    
     override func viewDidLoad() {
        print("MapViewController loaded")
        mapView.mapType = MKMapType.Hybrid
        mapView.zoomEnabled = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
   
        retriveNotificationsByOwnerID()
        
    
    
    
           }
    
    
    
    
    func retriveNotificationsByOwnerID() {
        let n = backendless.userService.currentUser.getProperty("ownerId") as! String
        let whereClause = "ownerId = '"+n+"'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        backendless.data.of(Notification.ofClass()).find(dataQuery,
            response: { (result: BackendlessCollection!) -> Void in
                //start block
                
                for b in result.data as! [Notification]{
                    print (b.lat)
                    if(b.isActive){
                        self.drawCirclesOnTheMap(b)}
                    
                    // TODO: delete
                    self.oldNotifications.append(b)
                    
                }
                //end block
            }, error: { (fault: Fault!) -> Void in
                print("fServer reported an error: \(fault)")
        })
    }


    
    override func viewWillDisappear(animated: Bool) {
        print("View Will Dissapear Called")
        
        storeNotificationsToBackEndless()
        
    }
    
    
    
    
    func drawCirclesOnTheMap(b: Notification){
    
        let cord = CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon)
        let circle = MKCircle(centerCoordinate: cord, radius: 2000)
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
                    print("Contact has been saved: \(obj.notificationTitle)")
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
            
            performSegueWithIdentifier("segueNewNot", sender: self)
         
            
        let touchLocation = myPressPoint.locationInView(mapView)
                let locationCoordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
            
            //let not = Notification(Desc: "Press",Title: "Test",Rad: 2000,Act: true,Loc: locationCoordinate)
            
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            let circle = MKCircle(centerCoordinate: locationCoordinate, radius: 2000)
            
           
            mapView.addOverlay(circle)
            
            
            mapView.delegate = self
            
            
            //New notification created save to notification list
            let notification = Notification(Desc: "MyTest1", Title: "2", Rad: 2000, Act: true, Lat :Double(locationCoordinate.latitude),Lon: Double(locationCoordinate.longitude))
            newNotifications.append(notification)
           
            
            
        
        
        }
               
        
    
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
    
}