//
//  NotificationsViewController.swift
//  GeoReminder
//
//  Created by Admin on 11.07.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit
class NotificationsViewController : UIViewController {
    
    
    override func viewDidLoad() {
        print("NotificationsViewController  Loaded")
       
        //test
        if let nots = Notification.loadNotificationsFromUserDefaults(){
            for n in nots{
                    print("\(n.lat)")
        
            }
        }
        //-test
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    
}