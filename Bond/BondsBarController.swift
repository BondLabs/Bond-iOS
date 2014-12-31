//
//  BondsBarController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondsBarController: UITabBarController {
    
    var views:[UIViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = self.viewControllers as [UIViewController]
        self.tabBar.backgroundColor = self.UIColorFromRGB(0x2D2D2D)
        self.tabBar.selectedImageTintColor = self.UIColorFromRGB(0x2D2D2D)
    }

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}