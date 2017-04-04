//
//  NightRideViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//
//View Controller For Night Ride drivers which displays the List of Pick up requests send by Users

import UIKit

class NightRideViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, Operation {
    
    var kinveyOp:KinveyOperations!
    var requestList:[RideRequests] = []
    var storeRequests:KCSAppdataStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Night Ride View Controller"
        kinveyOp = KinveyOperations(operations: self)
        kinveyOp.retrieveData()
        storeRequests = KCSAppdataStore.storeWithOptions([
            // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "RideRequests",
            KCSStoreKeyCollectionTemplateClass : RideRequests.self
            ])
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestList.count
    }
    
    //Custom cell to display the pick up requests
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("nightRideCell", forIndexPath: indexPath)
        let label1:UILabel = cell.viewWithTag(101) as! UILabel
        let label2:UILabel = cell.viewWithTag(102) as! UILabel
        let label3:UILabel = cell.viewWithTag(103) as! UILabel
        let label4:UILabel = cell.viewWithTag(104) as! UILabel
        let label5:UILabel = cell.viewWithTag(105) as! UILabel
        label1.text = indexPath.row.description
        label2.text = requestList[indexPath.row].pickUpLocation as String
        label4.text = requestList[indexPath.row].noOfPassengers as String
        label3.text = requestList[indexPath.row].dropOffLocation as String
        label5.text = requestList[indexPath.row].phone as String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    
    @IBAction func deleteRow(sender: AnyObject) {
        let rowNumber = (tableView.indexPathForSelectedRow?.row)!
        storeRequests.removeObject(
            requestList[rowNumber],
            withDeletionBlock: { (deletionDictOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
            },
            withProgressBlock: nil
        )
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func onSuccess(sender:AnyObject) {
    }
    
    func onError(message: String) {
    }
    
    //fetches the pick up requests
    func fetchRequests(request:[RideRequests]) {
        requestList = request
        self.tableView.reloadData()
    }
    
    func fetchDriverData(driver:[DriverData]){
    }
    
    //to dismiss a request once it is done
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            requestList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}
