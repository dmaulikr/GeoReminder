//
//  NotificationViewController.swift
//  Georeminder
//
//  Created by admin on 7/20/16.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import Foundation
import UIKit

class NotificationViewController: UITableViewController {
    var backendless = Backendless.sharedInstance()
    var oldNotifications: [Notification] = []
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicatorLarge: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        print("NotificationsViewController  Loaded")
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicatorLarge.startAnimating()
    retriveNotificationsByOwnerID()
        activityIndicatorLarge.stopAnimating()
        activityIndicatorLarge.hidesWhenStopped = true
        activityView.hidden = true
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! NotificationTableViewCell
        
        cell.statusSwitch.on = oldNotifications[indexPath.row].isActive
        cell.titleLable.text = oldNotifications[indexPath.row].notificationTitle
        cell.descriptionLable.text = oldNotifications[indexPath.row].notificationDescription
        cell.statusLable.text = oldNotifications[indexPath.row].isActive ? "Active" : "InActive"
        cell.statusSwitch.tag = indexPath.row
        cell.statusLable.tag = indexPath.row
        cell.statusSwitch.addTarget(self, action: "SwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        return cell
    }
    
    func SwitchChanged(sender: UISwitch){
        
        
        print(sender.tag)
       let cell =  tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! NotificationTableViewCell
        
        
        cell.statusLable.text = cell.statusSwitch.on ? "Active" : "InActive"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(oldNotifications.count)
        
    return oldNotifications.count
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func retriveNotificationsByOwnerID() {
        let n = backendless.userService.currentUser.getProperty("ownerId") as! String
        let whereClause = "ownerId = '"+n+"'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        var error: Fault?
        let bc = Backendless.sharedInstance().data.of(Notification.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            print("Contacts have been found:")
        }
        else {
            print("Server reported an error: \(error)")
        }
    
    
    for b in bc.data as! [Notification]{
    
        oldNotifications.append(b)
    }
        
    }


}
