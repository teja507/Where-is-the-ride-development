//
//  DriverData.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//
// Model calss for Driver Data used for Driver registration
import Foundation

class DriverData: NSObject{

    var emailId:String!
    var user:String!
    var contact:String!
    var lastName:String!
    var password:String!

    var entityId: String?
    
    override init() {
        super.init()
    }
    
    init(user:String,password:String,emailId:String,contact:String,lastName :String) {
        self.user = user
        self.password = password
        self.emailId = emailId
        self.contact = contact
        self.lastName = lastName
        
        
    }

    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "user" : "user",
            "password" : "password",
            "emailId" : "emailId",
             "lastName" : "lastName",
              "contact" : "contact"      ]
    }
    
}
