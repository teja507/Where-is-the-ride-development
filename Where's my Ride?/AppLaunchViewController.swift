//
//  ViewController.swift
//  Where's my Ride?
//
//  Created by Sai Teja on 3/12/16.
//  Copyright © 2016 Sai Teja. All rights reserved.
//

import UIKit

class AppLaunchViewController: UIViewController {

    @IBOutlet weak var userBTN: UIButton!
    
    @IBOutlet weak var driverBTN: UIButton!

    @IBAction func userNextViewFunction(sender: AnyObject) {
        
        
        //Code to be written for the users next view
        
        
    }
    
    @IBAction func driverNextViewFunction(sender: AnyObject) {
        
        
        //Code to be written for the drivers next view
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Where's my Ride?"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

