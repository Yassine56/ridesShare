//
//  File.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/28/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTo(alphaValue: CGFloat, duration: TimeInterval){
        UIView.animate(withDuration: duration) animations: {
            self.alpha = alphaValue
        }
    }
}
