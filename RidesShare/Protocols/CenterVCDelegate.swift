//
//  CenterVCDelegate.swift
//  RidesShare
//
//  Created by Abouelouafa Yassine on 12/27/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

protocol CenterVCdelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool) // true to expand, false to collapse
}

