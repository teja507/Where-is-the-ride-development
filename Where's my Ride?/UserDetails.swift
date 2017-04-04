//
//  UserDetails.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//

// Model class for User Data

import Foundation

class UserDetails :NSObject {
    var username:String!
    var password:String!
    
    var entityId:String?
    
    init(username :String,password:String)
    {
        self.username = username
        self.password = password
    }

    override init() {
        self.entityId = "1"
        self.username = "Abhinaya"
        self.password = "1234"
    }
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "username" : "username",
            "password" : "password"
        ]
    }
}
