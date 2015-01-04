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
    }
}