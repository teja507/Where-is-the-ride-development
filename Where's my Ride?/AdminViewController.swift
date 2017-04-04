//
//  AdminViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//
//View Controller for Admin Login
import UIKit

class AdminViewController: UIViewController {
    
    @IBOutlet weak var adminUserNameTF: UITextField!
    
    @IBOutlet weak var adminPwdTF: UITextField!
    
    var store1:KCSAppdataStore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        store1 = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "Admin",
            KCSStoreKeyCollectionTemplateClass : Admin.self
            ])
        
        self.navigationItem.title = "Admin Login"
        self.navigationItem.backBarButtonItem = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
       
        
        self.navigationItem.title = "Admin Login"
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // Method for Registering admin when we click on Register button
    // We used register option initially to add admin and disabled it later
    //Since we should not give rights for anonymous user to register himself as admin
    //In below method storing admin object in both KCSUsers and separate collection named "Admin"
    @IBAction func adminRegisterBTN(sender: AnyObject) {
        let admin:Admin=Admin(userName: adminUserNameTF.text! ,password:adminPwdTF.text!)
        KCSUser.userWithUsername(
            adminUserNameTF.text!,
            password: adminPwdTF.text!,
            fieldsAndValues: nil,
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    //was successful!
                    self.displayAlertControllerWithTitle("Account Creation Successful", message: "User created. Welcome!")
                } else {
                    //there was an error with the update save
                    let message = errorOrNil.localizedDescription
                    self.displayAlertControllerWithTitle("Create account failed", message: message)
                }
            }
        )
        
        store1.saveObject(
            admin,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                    print("Save failed, with error: %@", errorOrNil.localizedFailureReason)
                } else {
                    //save was successful
                    print("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                }
            },
            withProgressBlock: nil
        )
        
        adminUserNameTF.text! = ""
        adminPwdTF.text! = ""
        
    }
    
    //Method which checks the login details of admin in Kinvey and validates
    @IBAction func adminLoginBTN(sender: AnyObject) {
        KCSUser.loginWithUsername(adminUserNameTF.text!,password: adminPwdTF.text!,withCompletionBlock:
            { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    
                    //Once login is successfull, navigates the admin to Driver list view
                    let destinationVC:AdminOperationsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("admin_Driver") as! AdminOperationsViewController
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                    
                    print("success")
                    
                } else {
                    
                    let message = errorOrNil.localizedDescription
                    self.displayAlertControllerWithTitle("Login failed", message: message)
                }
            }
        )
    }
    
    @IBOutlet weak var resetBTN: UIButton!
    
    //to reset the text fields to blank ,action method for Reset button
    @IBAction func resetBTNaction(sender: AnyObject) {
        adminUserNameTF.text = ""
        adminPwdTF.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
}
