//
//  RoundedCornerTextField.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/29/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class RoundedCornerTextField: UITextField {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = self.layer.frame.width / 2
    }
}
