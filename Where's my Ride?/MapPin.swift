//
//  MapViewWithAnnotation.swift
//  Where's my Ride?
//
//  Created by Sai Teja on 4/20/16.
//  Copyright © 2016 Sai Teja. All rights reserved.
//
//Model class for Map Pin
import Foundation
import MapKit
class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var color: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, color: String) {
        self.coordinate = coordinate
        self.title = title
        self.color = color
        self.subtitle = subtitle
    }
    //returns the pin color
    func pinColor() -> MKPinAnnotationColor {
        switch color {
        default :
            return .Green
        }
        
    }
}
