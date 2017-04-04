//
//  RideRequests.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//
// Model class  for Pick up requests send by user
import Foundation

class RideRequests: NSObject {
    
    var pickUpLocation:String!
    var dropOffLocation:String!
    var noOfPassengers:String!
    var phone:String!
    var entityId:String?
    var requestArray:[RideRequests]!
    
    init(pickUp:String,dropOffLocation:String,noOfPassengers:String,phone:String){
        self.pickUpLocation = pickUp
        self.dropOffLocation = dropOffLocation
        self.noOfPassengers = noOfPassengers
        self.phone = phone
    }
    
    override init() {
        self.entityId = "1"
        self.pickUpLocation = "Horizons"
        self.dropOffLocation = "Walmart"
        self.noOfPassengers = "5"
        self.phone = "7659803456"
        self.requestArray = []
    }
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "pickUpLocation" : "pickUpLocation",
            "dropOffLocation" : "dropOffLocation",
            "noOfPassengers" : "noOfPassengers",
            "phone" : "phone"
        ]
    }
}
