//
//  LeftSidePanelVC.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/27/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Firebase
class LeftSidePanelVC: UIViewController {
    
    var delegate: CenterVCdelegate?

    var appDelegate = AppDelegate.getAppDelegate()
    @IBOutlet var pickUpSwitch: UISwitch!
    
    @IBOutlet var accountTypeLabel: UILabel!
    @IBOutlet var pickUpModeLabel: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profileImage: RoundImage!
    
    @IBOutlet var signupLoginLabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickUpSwitch.isHidden = true
        pickUpModeLabel.text = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
           
            accountTypeLabel.text = ""
            emailLabel.text = ""
            profileImage.isHidden = true
            signupLoginLabel.setTitle("Sign up / Login", for: .normal)
        }else {
            
            profileImage.isHidden = false
            signupLoginLabel.setTitle("Sign out", for: .normal)
            observePassengersAndDrivers()
        }
    }
    func observePassengersAndDrivers() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshott) in
            if let snapshot = snapshott.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                       self.emailLabel.text = Auth.auth().currentUser?.email
                        self.accountTypeLabel.text = "PASSENGER"
                    }
                }
            }
        }
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.pickUpSwitch.isHidden = false
                        self.pickUpModeLabel.text = "Pick up Mode enabled"
                        self.pickUpSwitch.isOn = snap.childSnapshot(forPath: "isPickUpModeEnabled").value as! Bool
                        self.emailLabel.text = Auth.auth().currentUser?.email
                        self.accountTypeLabel.text = "Driver"
                        
                    }
                }
            }
        }
       
    }

    @IBAction func signupLoginWasPressed(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            let UIstoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = UIstoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        }else {
            do {
                try Auth.auth().signOut()
                pickUpSwitch.isHidden = true
                pickUpModeLabel.text = ""
                accountTypeLabel.text = ""
                emailLabel.text = ""
                profileImage.isHidden = true
                signupLoginLabel.setTitle("Sign up / Login", for: .normal)
            }
                catch (let error){
                print(error)
                
            }
        }
        
    }
    
    @IBAction func switchPickupModePressed(_ sender: Any) {
        let userkey = Auth.auth().currentUser?.uid
        if pickUpSwitch.isOn {
            pickUpModeLabel.text = "Pickup Mode Enabled"
            appDelegate.menuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(userkey!).updateChildValues(["isPickUpModeEnabled": true])
        }else {
            pickUpModeLabel.text = "Pickup Mode Disabled"
            appDelegate.menuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(userkey!).updateChildValues(["isPickUpModeEnabled": false])
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
