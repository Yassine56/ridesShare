//
//  LoginVC.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/29/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController {
    @IBOutlet var segmtedControl: UISegmentedControl!
    @IBOutlet var authBtn: RoundshadowanimButton!
    @IBOutlet var passwordTextField: RoundedCornerTextField!
    @IBOutlet var emailTextFiel: RoundedCornerTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyBoard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard(tapgesturereco:)))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyBoard(tapgesturereco: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
   
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func authbtnWasPressed(_ sender: Any) {
        if ( emailTextFiel.text != nil && passwordTextField.text != nil){
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            if let email = emailTextFiel.text , let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        if let user = user {
                            if self.segmtedControl.selectedSegmentIndex == 0 {
                                let userData = ["provider": user.providerID] as [String: Any]
                                DataService.instance.createFireBaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            }else {
                                let userData = ["provider": user.providerID, "userIsDriver": true, "isPickUpModeEnabled": false, "driverIsOnATrip": false] as [String: Any]
                                DataService.instance.createFireBaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        print("user signed up successfully using Firebase")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                            case .wrongPassword :
                                print("wrong password or email already in use")
                                self.view.endEditing(false)
                                self.authBtn.animateButton(shouldLoad: false, withMessage: "Sign up/ login")
                            default :
                                print("an error has occured please try again")
                
                        }
                        }
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            } else {
                                if let user = user {
                                    
                                    if self.segmtedControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider": user.providerID] as [String: Any]
                                        DataService.instance.createFireBaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    }else {
                                        let userData = ["provider": user.providerID, "userIsDriver": true, "isPickUpModeEnabled": false, "driverIsOnATrip": false] as [String: Any]
                                        DataService.instance.createFireBaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                    
                                }
                                print("new user was successfully created")
                                self.dismiss(animated: true, completion: nil )
                            }
                        })
                    }
                })
            }
            
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
