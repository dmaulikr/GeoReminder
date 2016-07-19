//
//  Notification.swift
//  Georeminder
//
//  Created by Admin on 19/07/2016.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import Foundation



class Notification : NSObject{
    
    
    var id = ""
    var notificationDescription : String!
    var notificationTitle :String?
    var notificationRadius = 0
    var isActive = true
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    
    
    init ( Desc : String, Title : String, Rad : Int, Act: Bool, Lat: Double, Lon: Double){
        self.id = NSUUID().UUIDString
        self.notificationDescription = Desc
        self.notificationTitle = Title
        self.notificationRadius = Rad
        self.isActive = Act
        self.lat = Lat
        self.lon = Lon
        
    super.init()
    }
    
    override init() {
        super.init()
        
    }
    
    
    
    
}