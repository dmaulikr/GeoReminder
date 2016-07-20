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
    var delegate : NotificationControllerDelegate?
    
    var notification : Notification?
   
    
    override func viewDidLoad() {
        Slider.maximumValue = 1000
        Slider.minimumValue = 10
        
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        RadiusLable.text = "\(Int(sender.value)) m"
        notification?.notificationRadius = Int(sender.value)
    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButtonPressed(sender: UIButton) {
        
        notification?.notificationTitle = TitleText.text
        notification?.notificationDescription = DescripText.text
        
        
        if((self.delegate) != nil)
        {
            
            delegate?.saveNotification(notification!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
}
