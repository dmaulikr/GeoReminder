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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        }
    }


    
}

