//
//  NewNotificationViewController.swift
//  Georeminder
//
//  Created by Admin on 19/07/2016.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import  UIKit

class NewNotificationViewController: UIViewController {
    
    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var DescripText: UITextField!
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var RadiusLable: UILabel!
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var Cancel: UIButton!
   
    
    override func viewDidLoad() {
        
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
