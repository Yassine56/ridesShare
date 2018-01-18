//
//  DriversAnnotation.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 1/16/18.
//  Copyright © 2018 Abouelouafa Yassine. All rights reserved.
//

import Foundation
import MapKit

class DriversAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, withkey key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    func update(annotationPosition annotation: DriversAnnotation, withCoordinate coordinate: CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
         
    }
    
}


