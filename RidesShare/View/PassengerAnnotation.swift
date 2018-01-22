//
//  PassengerAnnotation.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 1/22/18.
//  Copyright © 2018 Abouelouafa Yassine. All rights reserved.
//

import Foundation
import MapKit

class PassengerAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, withkey key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
}
}

