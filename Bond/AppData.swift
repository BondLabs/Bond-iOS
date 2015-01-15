//
//  AppData.swift
//  Bond
//
//  Created by Kevin Zhang on 1/3/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class AppData {
    struct data {
        static var userID:Int!
		static var statusBarHeight:CGFloat! = UIApplication.sharedApplication().statusBarFrame.height
		static var navBarHeight:CGFloat! = UINavigationController().navigationBar.frame.height
		static var tabBarHeight:CGFloat! = UITabBarController().tabBar.frame.height
		static var normViewHeight:CGFloat! = UIScreen.mainScreen().bounds.height - statusBarHeight
		static var navViewHeight:CGFloat! = normViewHeight - navBarHeight
		static var tabBarViewHeight:CGFloat! = navViewHeight - tabBarHeight
    }
    
    struct util {
        static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }

		static func scaleImage(image: UIImage, size: CGSize, inset: CGFloat) -> UIImage {
			var smallSize = CGSizeMake(size.width - CGFloat(inset), size.height - CGFloat(inset))
			UIGraphicsBeginImageContextWithOptions(smallSize, false, 0)
			image.drawInRect(CGRect(origin: CGPointZero, size: smallSize))
			var scaled:UIImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return scaled
		}
    }
}