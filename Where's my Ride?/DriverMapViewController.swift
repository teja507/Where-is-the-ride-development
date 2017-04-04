//
//  DriverMapViewController.swift
//  Where's my Ride?
//
//  Copyright © 2016 Sai Teja. All rights reserved.
//View Controller for Driver Map view, which displays locations of all drivers on ride

import UIKit
import MapKit

class DriverMapViewController: UIViewController, MKMapViewDelegate ,CLLocationManagerDelegate ,Operation{
    
    @IBOutlet weak var locationView: MKMapView!
    let locationManager = CLLocationManager()
    var locationService:KCSAppdataStore!
    var kinveyObject :KinveyOperations!
    var previousLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var driversLocation = [Driver]!()
    var driverAnnotation = [MapPin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightButton = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: "refreshTheViewController:")
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "Current Route"
        kinveyObject = KinveyOperations(operations: self)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationView.showsUserLocation = true
        locationService = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
            KCSStoreKeyCollectionName : "DriversLocation",
            KCSStoreKeyCollectionTemplateClass : Driver.self
            ])
        self.driverLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshTheViewController(sender: AnyObject) {
        self.view.setNeedsDisplay()
    }

    //Method for updating driver location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location!.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        self.locationView.setRegion(coordinateRegion, animated: true)
        let circle = MKCircle(centerCoordinate: center, radius: regionRadius)
        self.locationView.addOverlay(circle)
        self.locationManager.stopUpdatingLocation()
    }
    
    //To draw overlay, to find the drivers in that location
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.redColor().colorWithAlphaComponent(0.2)
            circleRenderer.strokeColor = UIColor.yellowColor().colorWithAlphaComponent(0.7)
            circleRenderer.lineWidth = 2
            
            return circleRenderer
        }
        return nil
    }
    
    //loads the current location of the drivers
    func driverLocation(){
        let query:KCSQuery = KCSQuery()
        locationService.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            self.driversLocation = objectsOrNil as! [Driver]
            for(var i=0;i<self.driversLocation.count;i++) {
                if (self.driversLocation[i].username != "driver1"){
                    let driver1Center = CLLocationCoordinate2D(latitude: self.driversLocation[i].location.coordinate.latitude, longitude: self.driversLocation[i].location.coordinate.longitude)
                    let driver1Annotation:MapPin = MapPin(coordinate: driver1Center, title: "\(self.driversLocation[i].username)Location", subtitle: "Iam here", color: "")
                    self.driverAnnotation.append(driver1Annotation)
                }
            }
            self.locationView.addAnnotations(self.driverAnnotation)
            }, withProgressBlock: nil)
    }
    
    //Returns the annotion view of the driver
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        
        let annotationReuseId = "Place"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
        if annotation is MKUserLocation {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
            anView!.image = UIImage(named: "Marker Filled-25.png")
            anView!.backgroundColor = UIColor.greenColor()
            anView!.canShowCallout = true
        }
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
            anView!.image = UIImage(named: "Taxi Filled-25.png")
            anView!.backgroundColor = UIColor.greenColor()
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
            anView!.image = UIImage(named: "Taxi Filled-25.png")
            anView!.backgroundColor = UIColor.greenColor()
            anView!.canShowCallout = true
        }
        return anView
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    //The below functions need to be kept for using Operation protocol
    func onSuccess(sender:AnyObject) {
    }
    
    func onError(message: String) {
    }
    
    func fetchDriverData(driver: [DriverData]) {
    }
    
    func fetchRequests(request:[RideRequests]){
    }
}
