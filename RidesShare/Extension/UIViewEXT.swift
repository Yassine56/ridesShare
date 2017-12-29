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
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alphaValue
        })
    }
    
    func bindToKeyBoard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
   @objc func keyboardwillChange(_ notification : NSNotification){
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
        
    }
}
