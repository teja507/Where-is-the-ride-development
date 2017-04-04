//
//  RideRequestViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//
//View Controller to send the ride request by User

import UIKit

class RideRequestViewController: UIViewController,Operation{
    
    @IBOutlet weak var contactNumberTF: UITextField!
    @IBOutlet weak var pickUpLocationTF: UITextField!
    @IBOutlet weak var dropLocationTF: UITextField!
    @IBOutlet weak var passengersTF: UITextField!
    var error:Bool = true
    var  kinveyObject :KinveyOperations!
    var store:KCSAppdataStore!
    var request:RideRequests!
    var pickupArray:[RideRequests]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickupArray = []
        self.kinveyObject = KinveyOperations(operations: self)
        store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "RideRequests",    // Collection to store the requests created by user
            KCSStoreKeyCollectionTemplateClass : RideRequests.self
            ])
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Request A Ride"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Validates the request details entered by user
    //And request send by User stored in Collection
    @IBAction func submitBTN(sender: AnyObject) {
        
        request = RideRequests(pickUp: pickUpLocationTF.text!, dropOffLocation: dropLocationTF.text!,noOfPassengers: passengersTF.text!, phone: contactNumberTF.text!)
        self.error = false
        if self.pickUpLocationTF.text != "self." && self.dropLocationTF.text != "" && self.passengersTF.text != "" && self.contactNumberTF.text != ""{
            if !Validation.isValidPassengers(self.passengersTF.text!) && !Validation.isValidContact(self.contactNumberTF.text!){
                self.error = false
            }
            else{
                self.error = true
            }
        }
        else{
            self.displayAlertControllerWithTitle("Invalid data!", message: "Please check the details entered.")
        }
        if self.error {
            store.saveObject(
                request,
                
                withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                    if errorOrNil != nil {
                        //save failed
                    } else {
                        self.displayAlertControllerWithTitle("Success!!!", message: "Pickup details are updated")
                    }
                    
                },
                withProgressBlock: nil
            )
        }else{
            self.displayAlertControllerWithTitle("Invalid data!", message: "Please check the details entered.")
        }
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:  nil))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
    
    func onSuccess(sender:AnyObject) {
        self.pickupArray = sender as! [RideRequests]
    }
    
    func onError(message: String) {
    }
    
    func fetchDriverData(driver: [DriverData]) {
    }
    
    func fetchRequests(request:[RideRequests]){
    }
}
