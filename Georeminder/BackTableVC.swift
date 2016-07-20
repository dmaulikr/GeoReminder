//
//  BackTableVC.swift
//  GeoReminder
//
//  Created by Admin on 09.07.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController{
    
    var TableArray = [String]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        print("BackTableVC  Loaded")
        TableArray = ["Map","Notifications","Log-Out"]
        imageArray = ["map","images-1","logout-512"]
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        let imageview = UIImage (named: imageArray[indexPath.row])
        
        cell.imageView?.image = imageview
        
        return cell
        
        
    }
    
    
    
}