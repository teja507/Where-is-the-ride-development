//
//  UserRegsiterViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.

//View Controller to register the User

import UIKit

class UserRegsiterViewController: UIViewController {
    
    
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    var store : KCSAppdataStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "RegisteredUser",
            KCSStoreKeyCollectionTemplateClass : Driver.self
            ])
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Sign Up"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    //Validates the User data entered for registration
    //Method to regiser the User in KCSUser and also in Registered User
    @IBAction func registerUserBTN(sender: AnyObject) {
        let user :UserDetails = UserDetails(username: userNameTF.text!, password: passwordTF.text!)
        KCSUser.userWithUsername(
            userNameTF.text!,
            password: passwordTF.text!,
            fieldsAndValues: nil,
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    //was successful!
                    if self.userNameTF.text != "" && self.firstNameTF.text != "" && self.lastNameTF.text != "" && self.contactTF.text != "" && self.placeTF.text != "self." && self.passwordTF.text != "" && self.confirmPasswordTF.text != ""{
                        if self.passwordTF.text == self.confirmPasswordTF.text{
                            self.displayAlertControllerWithTitle("Account Creation Successful", message: "User created. Welcome!")
                            let destinationVC:UserLoginViewController = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("UserLoginViewController") as! UserLoginViewController
                            self.navigationController?.pushViewController(destinationVC, animated: true)
                        }else{
                            self.displayAlertControllerWithTitle("Create account failed", message: "Password and Confirm Password must be same.")
                        }
                    }else{
                        self.displayAlertControllerWithTitle("Create account failed", message: "Please enter all the fields")
                    }
                    
                } else {
                    let message = errorOrNil.localizedDescription
                    self.displayAlertControllerWithTitle("Create account failed", message: message)
                }
            }
        )
        
        store.saveObject(
            user,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                } else {
                    //save was successful
                }
            },
            withProgressBlock: nil
        )
    }
    
    //Alert for successful registartion
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
    
}
