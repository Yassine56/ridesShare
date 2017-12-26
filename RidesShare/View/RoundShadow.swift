//
//  RoundShadow.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/25/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class RoundShadow: UIView {

    override func awakeFromNib() {
        setupView()
    }
    
   func setupView() {
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.cornerRadius = 5.0
    }

}
