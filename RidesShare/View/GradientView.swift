//
//  GradientView.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/23/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class GradientView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        setupGradientView()
    }
    
    let gradient = CAGradientLayer()
    func setupGradientView() {
        
        gradient.colors = [UIColor.white.cgColor,UIColor.init(white:1.0 , alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x:0 , y:1)
        gradient.locations = [0.8, 1.0]
        self.layer.addSublayer(gradient)
    }

}
