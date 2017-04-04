//
//  DriverRoutesViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.

//  Contains the routes that a driver will choose from
import UIKit

class DriverRoutesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var routes:DriverRoutes!
    
    //This fucntion displays the alert box showing the message for user  to turn on the location
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select a Route"
        routes = DriverRoutes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.routeDictionary.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("route_cell")!
        var keysArray:[String] =  []
        for key in routes.routeDictionary.keys.sort(){
            keysArray.append(key)
        }
        cell.textLabel?.text = keysArray[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBOutlet weak var tableVIew: UITableView!
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueID1"{
            if let rdTVC:RouteDetailsTableViewController = segue.destinationViewController as? RouteDetailsTableViewController{
                if let comingView = tableVIew.indexPathForSelectedRow?.row{
                    var route:[String] = []
                    for value:String in routes.routeDictionary.values{
                        route.append(value)
                    }
                    
                   rdTVC.routes  = route[comingView]
                }
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationItem.title = "Navigation Map"
        displayAlertController("Location", message: "Turn On Location Services to Allow Maps To Determine your Location")
    }
    
    //This fucntion displays the alert box showing the message for user  to turn on the location
    func displayAlertController(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
