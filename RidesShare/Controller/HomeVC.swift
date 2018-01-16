//
//  ViewController.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/23/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import RevealingSplashView
import CoreLocation
import MapKit

class HomeVC: UIViewController,MKMapViewDelegate {

    @IBOutlet var mapview: MKMapView!
    @IBOutlet var actionbutton: RoundshadowanimButton!
    var delegate: CenterVCdelegate?
    var manager: CLLocationManager?
    var regionRedius: CLLocationDistance = 1000
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.startUpdatingLocation()
        }else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnUserLocation(){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapview.userLocation.coordinate, regionRedius * 2.0, regionRedius * 2.0)
        mapview.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    
    @IBAction func centerButtonWasPressed(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    @IBAction func actionbuttonpressed(_ sender: Any) {
        actionbutton.animateButton(shouldLoad: true, withMessage: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthStatus()
     mapview.delegate = self
        centerMapOnUserLocation()
        
        
       
        let splashview = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
        splashview.animationType = .heartBeat
        splashview.startAnimation()
        
        splashview.heartAttack = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
        if status == .authorizedAlways {
            
            mapview.showsUserLocation = true
            mapview.userTrackingMode = .follow
        }
    }
}






