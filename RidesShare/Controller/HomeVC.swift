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
import Firebase

class HomeVC: UIViewController,MKMapViewDelegate {

    @IBOutlet var destinationCircle: CircleView!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var centerbtnoutlet: UIButton!
    @IBOutlet var mapview: MKMapView!
    @IBOutlet var actionbutton: RoundshadowanimButton!
    var searchResults = [MKMapItem]()
    var delegate: CenterVCdelegate?
    var manager: CLLocationManager?
    var regionRedius: CLLocationDistance = 1000
    var tableView = UITableView()
    let currentUserId = "4"  // Auth.auth().currentUser?.uid check auth first
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.startUpdatingLocation()
        }else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func loadDriverAnnotationFromFB(){
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let driverSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for driver in driverSnapshot {
                    if driver.hasChild("userIsDriver"){
                        if driver.hasChild("coordinate") {
                            if driver.childSnapshot(forPath: "isPickUpModeEnabled").value as? Bool == true {
                                if let driverDict = driver.value as? Dictionary<String,AnyObject> {
                                    let coordinateArray = driverDict["coordinate"] as! NSArray
                                    let drivercoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                                    let annotation = DriversAnnotation(coordinate: drivercoordinate, withkey: driver.key)
                                    var driverIsVisible: Bool {
                                        return self.mapview.annotations.contains(where: { (annotation) -> Bool in
                                            if let driverannotation = annotation as? DriversAnnotation {
                                                if driverannotation.key == driver.key {
                                                    driverannotation.update(annotationPosition: driverannotation, withCoordinate: drivercoordinate)
                                                    return true
                                                }
                                            }
                                            return false
                                        })
                                    }
                                    if driverIsVisible == false{
                                        self.mapview.addAnnotation(annotation)
                                    }
                                }
                            }else {
                                for annotation in self.mapview.annotations {
                                    if annotation.isKind(of: DriversAnnotation.self) {
                                        if let annotation = annotation as? DriversAnnotation {
                                            if annotation.key == driver.key {
                                                self.mapview.removeAnnotation(annotation)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            }
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
        centerbtnoutlet.fadeTo(alphaValue: 0.0, duration: 0.2)
    }
    
    @IBAction func actionbuttonpressed(_ sender: Any) {
        actionbutton.animateButton(shouldLoad: true, withMessage: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        destinationTextField.delegate = self
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthStatus()
     mapview.delegate = self
        centerMapOnUserLocation()
        DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
             self.loadDriverAnnotationFromFB()
        }
       
        
        
       
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

     func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        UpdateService.instance.updateDriversLocation(withCoordinate: userLocation.coordinate)
        UpdateService.instance.updateUsersLocation(withCoordinate: userLocation.coordinate)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriversAnnotation {
            let identifier = "Driver"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "driverAnnotation")
            return view
        }else if let annotation = annotation as? PassengerAnnotation {
            let identifier = "Passenger"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "passengerAnnotation")
            view.image = UIImage(named: "currentLocationAnnotation")
            return view
        }
        else{
        return nil
        }
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        centerbtnoutlet.fadeTo(alphaValue: 1.0, duration: 0.2)
    }
    
    func performSearch(){
        searchResults.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = destinationTextField.text
        request.region = mapview.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if response?.mapItems.count == 0 {
                    print("no result")
                } else {
                    for item in response!.mapItems {
                        self.searchResults.append(item)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    
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
extension HomeVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == destinationTextField {
        tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
        tableView.layer.cornerRadius = 5.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tag = 18
            tableView.rowHeight = 60
            view.addSubview(tableView)
            animatetableview(shouldShow: true)
            UIView.animate(withDuration: 0.2, animations: {
                 self.destinationCircle.backgroundColor = UIColor.red
                self.destinationCircle.borderColor = UIColor.init(red: 199/255, green: 0, blue: 0, alpha: 1)
            })
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == destinationTextField {
            performSearch()
            view.endEditing(true)
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchResults.removeAll()
        tableView.reloadData()
        centerMapOnUserLocation()
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == destinationTextField {
            if destinationTextField.text == "" {
                UIView.animate(withDuration: 0.2, animations: {
                    self.destinationCircle.backgroundColor = UIColor.lightGray
                    self.destinationCircle.borderColor = UIColor.darkGray
                })
            }
        }
    }
    func animatetableview(shouldShow: Bool){
        if shouldShow {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.frame = CGRect(x: 20, y: 170, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
            })
        }else {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
            }, completion: { (finished) in
                if finished {
                    for subview in self.view.subviews {
                        if subview.tag == 18 {
                            subview.removeFromSuperview()
                        }
                    }
                }
            })
        }
    }
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if destinationTextField.text == "" {
            view.endEditing(true)
            animatetableview(shouldShow: false)

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "LocationCell")
        let mapitem = searchResults[indexPath.row]
         cell.textLabel?.text = mapitem.name
        cell.detailTextLabel?.text = mapitem.placemark.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let passengerCoordinate = manager?.location?.coordinate
        let passengerAnnotation = PassengerAnnotation(coordinate: passengerCoordinate!, withkey: currentUserId)
        mapview.addAnnotation(passengerAnnotation)
        
        animatetableview(shouldShow: false)
        print("row selected")
    }
}


