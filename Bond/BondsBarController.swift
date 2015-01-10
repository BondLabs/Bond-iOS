//
//  BondsBarController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondsBarController: UITabBarController {
    
    // Store controller properties
    var views:[UIViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = self.viewControllers as [UIViewController]

		var barHeight:CGFloat = 49.0
		var bondIcon = UIImage(named: "Bonds(i).png")!
		var finalBG:UIImage
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.width / 2, barHeight), true, 0.0)
		AppData.util.UIColorFromRGB(0x2D2D2D).setFill()
		UIRectFill(CGRect(origin: CGPointZero, size: CGSizeMake(self.view.frame.width / 2, barHeight)))
		bondIcon.drawInRect(CGRectMake(self.view.frame.width / 6 + 10, 10, self.view.frame.width / 6 - 20, self.view.frame.width / 6 - 20))
		finalBG = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		views[0].tabBarItem.selectedImage = finalBG
    }
}