//
//  ViewController.swift
//  Georeminder
//
//  Created by Admin on 0807..16.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var backendless = Backendless.sharedInstance()
    var appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var locationController: CoreLocationController!
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationController = appDel.coreLocationController!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        let currentUser = backendless.userService.currentUser
        
        //check if user logged in, if no - redirect to login/register
        if (currentUser == nil){
            performSegueWithIdentifier("segueLogin", sender: self)
        }else{
            label.text = "hello, \(currentUser.name)"
        }
    }


    @IBAction func logoutTapped(sender: AnyObject) {
        backendless.userService.logout(
            { ( user : AnyObject!) -> () in
                print("User logged out.")
                self.performSegueWithIdentifier("segueLogin", sender: self)
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })
    }
    
    @IBAction func SetLocationTapped(sender: AnyObject) {
    
        let coord = CLLocationCoordinate2D(latitude: -26.2041028, longitude: 28.0473051) // johannesbourg
        let region = CLCircularRegion(center: coord, radius: 20, identifier: "Test")
        locationController.locationManager.startMonitoringForRegion(region)
        
    }
}

