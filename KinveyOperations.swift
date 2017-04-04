//
//  KinveyOperations.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//

import Foundation
import UIKit


// Operation protocol to assign delegation authority
@objc protocol Operation{
    func onSuccess(sender:AnyObject)
    func onError(message:String)
    func fetchDriverData(driver:[DriverData])
    func fetchRequests(request:[RideRequests])
    
}

//class to perform kinvey operation - create, fetch and for updating the data in to collection
class KinveyOperations {
    
    var storeDriver:KCSAppdataStore!       // Collection for Storing Registered driver data
    var storeDriverStatus:KCSAppdataStore! // Collection for Updating driver status whether he is on rie or not
    var storeLocation:KCSAppdataStore!     // Colllection for storing driver location
    var storeRequests:KCSAppdataStore!     //Collection for storing pick up requests
    var operationDelegate:Operation!        // Reference for Operation delegate
    
    
    
    init(operations:Operation)
    {
        self.operationDelegate = operations
        
        storeDriver = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "RegisteredDrivers",
            KCSStoreKeyCollectionTemplateClass : DriverData.self
            ])
        
        storeDriverStatus = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "DriverStatus",
            KCSStoreKeyCollectionTemplateClass : DriverData.self
            ])
        
        storeLocation = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "DriversLocation",
            KCSStoreKeyCollectionTemplateClass : Driver.self
    
            ])
        storeRequests = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "RideRequests",
            KCSStoreKeyCollectionTemplateClass : RideRequests.self
            ])
        
    }
    
// Fetching Pick up requests send by user
    func retrieveData() {
        print("inretrieve data")
        let query = KCSQuery()
        print(query.description)
        storeRequests.queryWithQuery(
            query,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                
                if errorOrNil == nil {
                    print("fetching")
                    //print(objectsOrNil[0])
                     let ride = objectsOrNil as! [RideRequests]
                    
                    print("requests in table list \(ride)")
        
                        self.operationDelegate.fetchRequests(ride)
                    
                    
                }
                else{
                    print(errorOrNil.description)
                }
                
            },
            withProgressBlock: nil
        )
        
    }
    
 // Adding driver registered to the Collection "Registered Drivers" and also KCSUser
    func addDriver(driver:DriverData) {
        
        KCSUser.userWithUsername(
            driver.user,
            password:driver.password,
            fieldsAndValues:[
                KCSUserAttributeEmail : driver.emailId ,
                //contact : driver.contact
            ],
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    //was successful!
                    //self.displayAlertControllerWithTitle("Account Creation Successful", message: "User created. Welcome!")
                    self.operationDelegate.onSuccess(driver)
                } else {
                    //there was an error with the update save
                    let message = errorOrNil.localizedDescription
                    //self.displayAlertControllerWithFailure("Create account failed", message: message)
                    self.operationDelegate.onError(message)
                }
            }
        )
        storeDriver.saveObject(
            driver,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                    print("Save failed in register driver, with error: %@", errorOrNil.localizedFailureReason)
                } else {
                    //save was successful
                    print("Successfully saved in register driver (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                }
            },
            withProgressBlock: nil
        )
    }
    
    //Fetching driver details from collection to display for Admin
    func fetchingDriverDetails() {
        
        let query = KCSQuery()
        print(query)
        storeDriver.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            if errorOrNil != nil {
                //save failed
                print("Fetching Failed: %@", errorOrNil.localizedFailureReason)
            }
            else {
                
                let driverDetails = objectsOrNil as! [DriverData]
                
                
                print("Successfully (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                print(driverDetails)
                self.operationDelegate.fetchDriverData(driverDetails)
            }
            
            }, withProgressBlock: nil)
        
        
    }
    
 //Fetching Driver Current Location stored in kinvey
    func driverLocation (driver:Driver) {
        storeLocation.saveObject(
            driver,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                    print("Save failed, with error: %@", errorOrNil.localizedFailureReason)
                } else {
                    //save was successful
                    print("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                }
            },
            withProgressBlock: nil )
        
    }
    
    
    // Deleting existing location of driver
   // And updating the driver location with current location
    func updateDriverLocation(driver:Driver)
    {
        var driverLocation:[Driver]!
        
        let userValue = driver.username
        
        print(userValue)
        
        let query = KCSQuery(onField: "username", withExactMatchForValue: userValue)
        
        storeLocation.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            
            if errorOrNil != nil {
                
                //save failed
                
                print("Update failed, with error: %@", errorOrNil.localizedFailureReason)
                
            } else {
                
                print(objectsOrNil.count)
                
                driverLocation = objectsOrNil as! [Driver]
                
                print("driver data to be update\(driverLocation)")
                
                self.deleteExistingLocation(driverLocation)
                
                
                print("Successfully updated new location (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
            }
            
            
            }, withProgressBlock: nil)
        
        
        
        
        storeLocation.saveObject(
            driver,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                    print("Update failed, with error: %@", errorOrNil.localizedFailureReason)
                } else {
                    //save was successful
                    print("Successfully updated new location (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                }            },
            withProgressBlock: nil)
    }
    
    // Method for Deleting existing object in kinvey-here deleting driver previous location object 
    func deleteExistingLocation(driverLocation:[Driver])
    {
        storeLocation.removeObject(
            
            driverLocation,
            withDeletionBlock: { (deletionDictOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    print("Delete object Failed")
                    
                } else {
                    print("driver location deleted successfully")
                    
                }
            },
            withProgressBlock: nil
        )
    }
    
}
