//
//  UserLoginViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.

//View Controller to authenticate the User -Login page

import UIKit

class UserLoginViewController: UIViewController {
    
    @IBOutlet weak var useLoginTF: UITextField!
    @IBOutlet weak var userPasswordTF: UITextField!
    
    @IBAction func resetBTN(sender: AnyObject) {
        useLoginTF.text = ""
        userPasswordTF.text = ""
    }
    
    var store:KCSAppdataStore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        store = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "RegisteredUsers",
            KCSStoreKeyCollectionTemplateClass : Driver.self
            ])
        self.navigationItem.title = "User Login"
        self.navigationItem.backBarButtonItem = nil
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    
    // Action method for SignIn method, validates the user details entered in KCSUser
    
    @IBAction func signInBTN(sender: AnyObject) {
        KCSUser.loginWithUsername(useLoginTF.text!,password: userPasswordTF.text!,withCompletionBlock:
            { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    let userMapViewController:UserMapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("userMapViewController") as! UserMapViewController
                    self.navigationController?.pushViewController(userMapViewController, animated: true)
                } else {
                    //there was an error with the update save
                    let message = errorOrNil.localizedDescription
                    self.displayAlertControllerWithTitle("Login failed", message: message)
                }
            }
        )
    }
    
    // Alert method shown when after successful login
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
}
