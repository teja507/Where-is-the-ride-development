//
//  DriverLoginViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//

import UIKit

class DriverLoginViewController: UIViewController,Operation {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var kinveyObject :KinveyOperations!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kinveyObject = KinveyOperations(operations: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Driver Login"
        usernameTF.text = ""
        passwordTF.text = ""
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.title = "Logout"
    }
    
    @IBAction func ResetBTN(sender: AnyObject) {
        usernameTF.text = ""
        passwordTF.text = ""
    }
    
    @IBAction func loginBTN(sender: AnyObject) {
        let appy = UIApplication.sharedApplication().delegate as! AppDelegate
        appy.name = self.usernameTF.text!
        KCSUser.loginWithUsername(usernameTF.text!,password: passwordTF.text!,withCompletionBlock:
            { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    let user = KCSUser.activeUser().username
                    print ("from KCSUser Activer User \(user) ")
                    let authorizedDriver:Driver = Driver(location:CLLocation(latitude:40.3497, longitude: -94.8806), username : self.usernameTF.text!)
                    self.kinveyObject.driverLocation(authorizedDriver)
                    self.defaults.synchronize()
                    let rideTypeTableViewController:RideTypeTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RideTypeTableViewController") as! RideTypeTableViewController
                    self.navigationController?.pushViewController(rideTypeTableViewController, animated: true)
                } else {
                    let message = "Username/Password is invalid"
                    self.displayAlertControllerWithTitle("Login Failed", message: message)
                }
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
    
    func onSuccess(sender:AnyObject) {
        print("status updated successfully")
    }
    
    func onError(message: String) {
    }
    
    func fetchDriverData(driver: [DriverData]) {
    }
    
    func fetchRequests(request:[RideRequests]){
        
    }
}
