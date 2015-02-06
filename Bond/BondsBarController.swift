//
//  BondsBarController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondsBarController: UITabBarController, UITabBarControllerDelegate {

	var selectedBGColor:UIColor! = AppData.util.UIColorFromRGB(0x212121)
	var deselectedBGColor:UIColor! = AppData.util.UIColorFromRGB(0x2D2D2D)
    
    // Store controller properties
    var views:[UIViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()

		// Set delegate
		self.delegate = self

		// Store view controllers
        views = self.viewControllers as [UIViewController]

		// Set up view properties
		self.tabBar.tintColor = AppData.util.UIColorFromRGB(0x575757)
		self.tabBar.translucent = false
		self.setItemSelected(0)

		// Create tabBarItem
		var bondsImage = AppData.util.scaleImage(UIImage(named: "Bonds.png")!, size: CGSizeMake(25, 16), scale:1.0)
		var profImage = AppData.util.scaleImage(UIImage(named: "Profile.png")!, size: CGSizeMake(25, 25), scale:1.0)

		views[0].tabBarItem = UITabBarItem(title: nil, image: bondsImage, selectedImage: bondsImage)
		views[1].tabBarItem = UITabBarItem(title: nil, image: profImage, selectedImage: profImage)
		views[0].tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
		views[1].tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        // Set up location services
        var location = CustomBLE.sharedInstance
        location.setup()
        location.scan()
    }

	// Change background color to match
	func setItemSelected(index: Int) {
		// Store relevant dimensions
		var itemCount = self.tabBar.items!.count
		var viewWidth = self.view.frame.width
		var itemWidth:CGFloat = viewWidth / CGFloat(itemCount)
		var barHeight:CGFloat = self.tabBar.frame.height
		var itemSize:CGSize = CGSizeMake(itemWidth, barHeight)
		var barSize:CGSize = CGSizeMake(viewWidth, barHeight)
        
		// Begin filling in image
		UIGraphicsBeginImageContextWithOptions(barSize, true, 0)
		self.deselectedBGColor.setFill()
		var context = UIGraphicsGetCurrentContext()
		CGContextFillRect(context, CGRect(origin: CGPointZero, size: barSize))
		self.selectedBGColor.setFill()
		CGContextFillRect(context, CGRect(origin: CGPointMake(CGFloat(index) * itemWidth, 0), size: itemSize))
		var bgImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		// Set background image to created image
		self.tabBar.backgroundImage = bgImage
	}

	// Get taps on view controllers
	func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		var itemIndex:Int = 0
		for (index, vc) in enumerate(tabBarController.viewControllers!) {
			if (vc as UIViewController == viewController) {
				itemIndex = index
			}
		}
		self.setItemSelected(itemIndex)
	}
}