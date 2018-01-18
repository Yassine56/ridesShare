//
//  UpdateService.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 1/16/18.
//  Copyright © 2018 Abouelouafa Yassine. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class UpdateService{
    static let instance = UpdateService()
    
    func updateUsersLocation(withCoordinate coordinate: CLLocationCoordinate2D){
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for user in snaps {
                    if user.key == Auth.auth().currentUser?.uid {
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["coordinate": [coordinate.latitude,coordinate.longitude]])
                    }
                    
                }
            }
        }
    }
    func updateDriversLocation(withCoordinate coordinate: CLLocationCoordinate2D){
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for driver in snaps {
                    if driver.key == Auth.auth().currentUser?.uid {
                        if driver.childSnapshot(forPath: "isPickUpModeEnabled").value as? Bool == true {
                        DataService.instance.REF_DRIVERS.child(driver.key).updateChildValues(["coordinate": [coordinate.latitude,coordinate.longitude]])
                    }
                    }
                }
            }
        }
    }
}
