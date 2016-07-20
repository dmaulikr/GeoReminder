//
//  Notification.swift
//  Georeminder
//
//  Created by Admin on 19/07/2016.
//  Copyright © 2016 SuperCoders. All rights reserved.
//

import Foundation



class Notification : NSObject, NSCoding{
    
    
    var id = ""
    var notificationDescription : String!
    var notificationTitle :String?
    var notificationRadius = 0
    var isActive = true
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    
   
    
    // MARK: - Conform to NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        //print("encodeWithCoder")
        aCoder.encodeObject(id, forKey: "keyID")
        aCoder.encodeObject(notificationDescription, forKey: "keyNotificationDescription")
        aCoder.encodeObject(notificationTitle, forKey: "keynotificationTitle")
        aCoder.encodeObject(notificationRadius, forKey: "keynotificationRadius")
        aCoder.encodeObject(isActive, forKey: "keyisActive")
        aCoder.encodeObject(lat, forKey: "keylat")
        aCoder.encodeObject(lon, forKey: "keylon")
        
    }

    
    
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
    
    init ( id: String,Desc : String, Title : String, Rad : Int, Act: Bool, Lat: Double, Lon: Double){
        self.id = id
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
    
    // since we inherit from NSObject, we're not a final class -> therefore this initializer must be declared as 'required'
    // it also must be declared as a 'convenience' initializer, because we still have a designated initializer as well
    required convenience init?(coder aDecoder: NSCoder) {
        // print("decodeWithCoder")
        guard let unarchivedId = aDecoder.decodeObjectForKey("keyID") as? String
            else {
                return nil
        }
        guard let unarchivedDes = aDecoder.decodeObjectForKey("keyNotificationDescription") as? String
            else {
                return nil
        }
        guard let unarchivedTitle = aDecoder.decodeObjectForKey("keynotificationTitle") as? String
            else {
                return nil
        }
        guard let unarchivedRadius = aDecoder.decodeObjectForKey("keynotificationRadius") as? Int
            else {
                return nil
        }
        guard let unarchivedActive = aDecoder.decodeObjectForKey("keyisActive") as? Bool
            else {
                return nil
        }
        guard let unarchivedLat = aDecoder.decodeObjectForKey("keylat") as? Double
            else {
                return nil
        }
        guard let unarchivedLon = aDecoder.decodeObjectForKey("keylat") as? Double
            else {
                return nil
        }
        // now (we must) call the designated initializer
        self.init(id:unarchivedId, Desc: unarchivedDes, Title: unarchivedTitle, Rad:unarchivedRadius, Act: unarchivedActive, Lat:unarchivedLat, Lon: unarchivedLon)
    }
    
    // MARK: - Archiving & Unasrchiving using NSUserDefaults
    
    class func saveNotificationsToUserDefaults(nots: [Notification]) {
        // first we need to convert our array of custom Player objects to a NSData blob, as NSUserDefaults cannot handle arrays of custom objects. It is limited to NSString, NSNumber, NSDate, NSArray, NSData. There are also some convenience methods like setBool, setInteger, ... but of course no convenience method for a custom object
        // note that NSKeyedArchiver will iterate over the 'players' array. So 'encodeWithCoder' will be called for each object in the array (see the print statements)
        let dataBlob = NSKeyedArchiver.archivedDataWithRootObject(nots)
        
        // now we store the NSData blob in the user defaults
        NSUserDefaults.standardUserDefaults().setObject(dataBlob, forKey: "NotificationsInUserDefaults")
        
        // make sure we save/sync before loading again
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func loadNotificationsFromUserDefaults() -> [Notification]? {
        // now do everything in reverse :
        //
        // - first get the NSData blob back from the user defaults.
        // - then try to convert it to an NSData blob (this is the 'as? NSData' part in the first guard statement)
        // - then use the NSKeydedUnarchiver to decode each custom object in the NSData array. This again will generate a call to 'init?(coder aDecoder)' for each element in the array
        // - and when that succeeded try to convert this [NSData] array to an [Player]
        guard let decodedNSDataBlob = NSUserDefaults.standardUserDefaults().objectForKey("NotificationsInUserDefaults") as? NSData,
            let loadedNotificationsFromUserDefault = NSKeyedUnarchiver.unarchiveObjectWithData(decodedNSDataBlob) as? [Notification]
            else {
                return nil
        }
        
        return loadedNotificationsFromUserDefault
    }

    
    
}