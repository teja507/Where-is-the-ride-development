//
//  RouteDetailsTableViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//  Contains the detailed view of the the routes selected by a driver

import UIKit

class RouteDetailsTableViewController: UITableViewController {
    
    var routes:String = ""
    var subRoutes:[String] = []
    
    override func viewDidLoad() {
        subRoutes = routes.componentsSeparatedByString(",")
        super.viewDidLoad()
        self.navigationItem.title = "Route details"
        
        //For confirming the route
        let rightButton = UIBarButtonItem(title: "Confirm", style: UIBarButtonItemStyle.Plain, target: self, action: "saveRoute:")
        
        navigationItem.rightBarButtonItem  = rightButton
        
        
    }
    
    //Confirms the route selected by the driver and sends the driver to the map view
    func saveRoute(sender:UIButton!){
        let driverMapViewController:DriverMapViewController = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("DriverMapViewController") as! DriverMapViewController
        
        self.navigationController?.pushViewController(driverMapViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subRoutes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("sub_routes")!
        cell.textLabel?.text = subRoutes[indexPath.row]
        return cell
    }
    
}
