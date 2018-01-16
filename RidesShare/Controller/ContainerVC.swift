//
//  ContainerVC.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/27/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case collapsed
    case leftPanelExpanded
}
enum ShowWhichVC {
    case homeVC
}

var showVC: ShowWhichVC = .homeVC




class ContainerVC: UIViewController {

    var centerController : UIViewController!
    var ishidden = false // for the status bar
    var centerPannelExpandedOffSet : CGFloat = 160
    var currentState: SlideOutState = .collapsed {
        didSet {
            let shouldShowShadow = (currentState != .collapsed)
           shouldShowShadowForCenterViewController(status: shouldShowShadow )
        }
    }
    var homeVC: HomeVC!
    var leftVC: LeftSidePanelVC!
    var tap: UITapGestureRecognizer!
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    override var prefersStatusBarHidden: Bool {
        return ishidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCenter(screen: .homeVC  )

        // Do any additional setup after loading the view.
    }

    func  initCenter(screen: ShowWhichVC){
        var presentingController: UIViewController
        showVC = screen
        
        if homeVC == nil {
            homeVC = UIStoryboard.homeVC()
            homeVC.delegate = self
        }
        presentingController = homeVC
        if let con = centerController {
            con.view.removeFromSuperview()
            con.removeFromParentViewController()
        }
        centerController = presentingController
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }
}

extension ContainerVC:CenterVCdelegate {
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    @objc func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand == true{
            ishidden = !ishidden
            animateStatusBar()
            setupWhiteCoverView()
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPannelExpandedOffSet)
            self.currentState = .leftPanelExpanded
        }else{
            ishidden = !ishidden
            animateStatusBar()
            hideWhiteCoverView()
            animateCenterPanelXPosition(targetPosition: 0, completion: { (didfinishanimating) in
                if didfinishanimating {
                    self.currentState = .collapsed
                    self.leftVC = nil
                }
            })
            
        }
    }
    
    func setupWhiteCoverView() {
        let coverView = UIView()
        coverView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        coverView.alpha = 0.0
        coverView.backgroundColor = UIColor.white
        coverView.tag = 11
        tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpand:)))
        tap.numberOfTapsRequired = 1
        coverView.addGestureRecognizer(tap)
        self.centerController.view.addSubview(coverView)
        UIView.animate(withDuration: 0.2) {
            coverView.alpha = 0.5
        }
    }
    func hideWhiteCoverView(){
        centerController.view.removeGestureRecognizer(tap )
        for subview in centerController.view.subviews {
            if subview.tag == 11 {
                UIView.animate(withDuration: 0.2, animations: {
                    subview.alpha = 0.0
                }, completion: { (didfinish) in
                   subview.removeFromSuperview()

                })
            }
        }
        
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion:((Bool) -> Void)! = nil ){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func addLeftPanelViewController() {
        if leftVC == nil {
           leftVC = UIStoryboard.leftViewController()
            addChildSidePanelViewController(leftVC!)
        }
    }
    
    func addChildSidePanelViewController(_ sidePanelViewController: LeftSidePanelVC){
        view.insertSubview(sidePanelViewController.view, at: 0)
        addChildViewController(sidePanelViewController)
        sidePanelViewController.didMove(toParentViewController: self)
        
        
        
    }
    func shouldShowShadowForCenterViewController(status: Bool){
        if status == true {
            leftVC.view.layer.shadowOpacity = 0.6
        }else {
            leftVC.view.layer.shadowOpacity = 0.0
        }
    }
}





private extension UIStoryboard {
    class func mainStoryBoard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    class func leftViewController() -> LeftSidePanelVC? {
        return mainStoryBoard().instantiateViewController(withIdentifier: "LeftSidePanelVC") as? LeftSidePanelVC
    }
    class func homeVC() -> HomeVC? {
        return mainStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    }
}
