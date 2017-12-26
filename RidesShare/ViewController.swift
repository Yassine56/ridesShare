//
//  ViewController.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/23/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var actionbutton: RoundshadowanimButton!
    
    @IBAction func actionbuttonpressed(_ sender: Any) {
        actionbutton.animateButton(shouldLoad: true, withMessage: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

