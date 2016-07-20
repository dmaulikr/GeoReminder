//
//  NotificationTableViewCell.swift
//  Georeminder
//
//  Created by admin on 7/20/16.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import Foundation
import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var tableImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    

    @IBAction func statusSwitchChanged(sender: UISwitch) {
        
        
    }
}
