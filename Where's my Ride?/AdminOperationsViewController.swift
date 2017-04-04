//
//  AdminOperationsViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//
//View Controller to display the list of Dirver regsitered by Admin

import UIKit

class AdminOperationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,Operation {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var driverDetails:[DriverData] = []
    
    var kinveyObject :KinveyOperations!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Added left barbutton to view controller and given action method to be called
        let leftButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
        leftButton.tintColor = UIColor.redColor()
        navigationItem.leftBarButtonItem  = leftButton
        
        //Added right barbutton which navigates the page , to regiter the new driver
        let rightButton = UIBarButtonItem(title: "AddDriver", style: UIBarButtonItemStyle.Plain, target: self, action: "add:")
        rightButton.tintColor = UIColor.redColor()
        navigationItem.rightBarButtonItem  = rightButton
        
        kinveyObject = KinveyOperations(operations: self)
        
        
        //reloading table with existing data
        tableView.reloadData()
        
        //fetching driver details added in the kinvey to display in table view
        kinveyObject.fetchingDriverDetails()
    }
    
    override func viewWillAppear(animated: Bool) {
        kinveyObject.fetchingDriverDetails()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Action method for logout button added
    func logout(Any:AnyObject){
        if KCSUser.activeUser() != nil {
            KCSUser.activeUser().logout()
            let destinationVC:AdminViewController = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("AdminViewController") as! AdminViewController
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }   }
    
    //Action method for Add Driver button
    func add(Any:AnyObject){
        
        // Navigating to register driver view controller
        let destination:RegisterDriverViewController = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("register") as! RegisterDriverViewController
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverDetails.count
    }
    
    //Cutom cell for table view  , mapping driver details in kinvey to field in table view cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let driverNameLBL:UILabel = cell.viewWithTag(100) as! UILabel
        let driverEmailLBL:UILabel = cell.viewWithTag(200) as! UILabel
        let driverContactLBL:UILabel = cell.viewWithTag(300) as! UILabel
        let driverImage:UIImageView = cell.viewWithTag(400) as! UIImageView
        driverNameLBL.text = driverDetails[indexPath.row].user
        driverEmailLBL.text = driverDetails[indexPath.row].emailId
        driverContactLBL.text = driverDetails[indexPath.row].contact
        driverImage.image = UIImage(named: "driver1.png")
        return cell
    }
    
    
    func onSuccess(sender:AnyObject) {
    }
    
    func onError(message: String) {
    }
    
    //Method for retrieving driver details from kinvey and stroing local array of Driver Details
    func fetchDriverData(driver: [DriverData]) {
        driverDetails = driver 
        tableView.reloadData()
    }
    
    func fetchRequests(request:[RideRequests]){
        
    }
    
    // method for deleting table view cell when you slide the cell
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            driverDetails.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
}







