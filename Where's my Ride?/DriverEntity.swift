//
//  DriverEntity.swift
//  Where's my Ride?
//
//  Created by Sai Teja on 3/31/16.
//  Copyright © 2016 Sai Teja. All rights reserved.
//  Contains the Driver which extends the NSObject class, so that Driver can contain Objective-C type objects

//Model class to store the active users current location fetched
import Foundation

class Driver: NSObject{
    var location:CLLocation!
    var username:String!
    var entityId: String?
    
    override init() {
        super.init()
    }
    
    init(location:CLLocation, username:String) {
        self.location = location
        self.username = username
    }
    
    //Maps the properties of the driver in kinvey
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "location" : "location",
            "username" : "username",
        ]
    }
    
}
