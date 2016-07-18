//
//  LogoutViewController.swift
//  GeoReminder
//
//  Created by Admin on 11.07.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

class LogoutViewController: UIViewController {
    var backendless = Backendless.sharedInstance()

    
    override func viewDidLoad() {
         print("LogoutViewController loaded")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        backendless.userService.logout(
            { ( user : AnyObject!) -> () in
                print("User logged out.")
                
                // close all views -> results in going back to Login
                self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                
              
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })
        
       
        
       
    }
    
    
    
}