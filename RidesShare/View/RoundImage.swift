//
//  RoundImage.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/25/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    
    }

}
