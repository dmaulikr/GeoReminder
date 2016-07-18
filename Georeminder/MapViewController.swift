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
  
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
     override func viewDidLoad() {
        print("MapViewController loaded")
        mapView.mapType = MKMapType.Hybrid
        mapView.zoomEnabled = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
        
    
    
        
    }
    
    /*override func viewDidAppear(animated: Bool) {
        
        let currentUser = backendless.userService.currentUser
        
        //check if user logged in, if no - redirect to login/register
        if (currentUser == nil){
            performSegueWithIdentifier("segueLogin", sender: self)
        }else{
            //label.text = "hello, \(currentUser.name)"
            print("User \(currentUser.name) is logged in")
            
            /*
            backendless.userService.logout(
                { ( user : AnyObject!) -> () in
                    print("User logged out.")
                    self.performSegueWithIdentifier("segueLogin", sender: self)
                    
                },
                error: { ( fault : Fault!) -> () in
                    print("Server reported an error: \(fault)")
            })
            */
            
            
        }
    }*/

    
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        
    }
    
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        
        
        print("Stepper Detected")
    }
    
    func longPress(myPressPoint:UILongPressGestureRecognizer){
        if (myPressPoint.state == UIGestureRecognizerState.Began){
        
        print("GESTURE Detected")
        let touchLocation = myPressPoint.locationInView(mapView)
                let locationCoordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            let circle = MKCircle(centerCoordinate: locationCoordinate, radius: 2000)
            
           // circle.radius
            mapView.addOverlay(circle)
            
            
            mapView.delegate = self
        
        
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