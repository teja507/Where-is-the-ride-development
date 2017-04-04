//
//  RegisterDriverViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.

//View Controller to Register the driver by Admin

import UIKit

class RegisterDriverViewController: UIViewController, Operation {
    
    @IBOutlet weak var driverPwdTF: UITextField!
    
    @IBOutlet weak var driverNameTF: UITextField!
    
    @IBOutlet weak var driverEmailTF: UITextField!
   
    @IBOutlet weak var driverLastNameTF: UITextField!
    
    @IBOutlet weak var driverContactTF: UITextField!
    
    var kinveyObject :KinveyOperations!
    
    var error:Bool = true
    
    @IBOutlet weak var confirmPwdTF: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        kinveyObject = KinveyOperations(operations: self)
        
        navigationItem.title = "Register Driver"
    }

    @IBAction func registerDriverBTN(sender: AnyObject) {
  
        self.error = false
        
        if self.driverNameTF.text != "" && self.driverLastNameTF.text != "" && self.driverContactTF.text != "" && self.driverEmailTF.text != "" && self.driverPwdTF.text != "" && self.confirmPwdTF.text != "" {
            
            if !Validation.isValidEmail(driverEmailTF.text!) && !Validation.isValidContact(self.driverContactTF.text!) && driverPwdTF.text != self.confirmPwdTF.text {
                self.error = false
            }
            else{
                self.error = true
            }
            
        }else{
            self.displayAlertControllerWithFailure("Invalid data!", message: "Please check the details entered.")
        }
        if self.error{
            let driver :DriverData = DriverData(user: driverNameTF.text!, password:  driverPwdTF.text!, emailId: driverEmailTF.text!, contact: driverContactTF.text!, lastName: driverLastNameTF.text!)
            self.kinveyObject.addDriver(driver)
        }else{
            displayAlertControllerWithFailure("Registration Failed", message: "Invalid data")
        }
        
    }

    func onError(message:String) {
        self.displayAlertControllerWithFailure("Create account failed", message: message)
    }
    func onSuccess(sender:AnyObject) {
        self.displayAlertControllerWithSuccess("Account Creation Successful", message: "User created. Welcome!")
        
    }
    func fetchDriverData(driver: [DriverData]) {
        
    }
    func fetchRequests(request:[RideRequests]){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    //method to clear the text fields once the Driver registered successfully
    func success(){
        self.driverNameTF.text = ""
        self.driverLastNameTF.text = ""
        self.driverContactTF.text = ""
        self.driverEmailTF.text = ""
        self.driverPwdTF.text = ""
        self.confirmPwdTF.text = ""
    }
    
    //alert method when successfully registered
    func displayAlertControllerWithSuccess(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        success()
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    
    //alert method when registration failed
    func displayAlertControllerWithFailure(title:String, message:String) {
        
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }

    
}
