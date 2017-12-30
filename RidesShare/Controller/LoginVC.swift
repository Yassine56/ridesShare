//
//  LoginVC.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/29/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
