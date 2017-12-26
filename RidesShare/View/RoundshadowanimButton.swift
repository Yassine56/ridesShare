//
//  RoundshadowanimButton.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/26/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class RoundshadowanimButton: UIButton {

    var originalSize = CGRect()
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        originalSize = self.frame
        
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        
    }
    
    func animateButton(shouldLoad : Bool, withMessage message: String?) {
        
        if shouldLoad {
            let spinner = UIActivityIndicatorView()
            spinner.activityIndicatorViewStyle = .whiteLarge
            spinner.hidesWhenStopped = true
            spinner.color = UIColor.darkGray
            spinner.alpha = 0.0
            spinner.tag = 10
            self.addSubview(spinner)
            self.setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.cornerRadius = self.frame.height / 2
                self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height)
            }, completion: { (finished) in
                if finished {
                    spinner.center = CGPoint(x: (self.frame.width / 2) + 1, y: (self.frame.width / 2) + 1)
                    spinner.startAnimating()
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        spinner.alpha = 1.0
                    })
                    
                }
            })
            self.isUserInteractionEnabled = false
        } else {
            self.isUserInteractionEnabled = true
            for subview in subviews {
                if subview.tag == 10 {
                    subview.removeFromSuperview()
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame = self.originalSize
                    self.setTitle(message, for: .normal)
                })
            }
        }
        
    }

}
