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
		static var viewWidth = UIScreen.mainScreen().bounds.width
		struct heights {
			static var navBarHeight:CGFloat! =  UINavigationController().navigationBar.frame.height
			static var navViewHeight:CGFloat! = normViewHeight - navBarHeight
			static var normViewHeight:CGFloat! = UIScreen.mainScreen().bounds.height - statusBarHeight
			static var pageControlHeight:CGFloat! = 36.0
			static var statusBarHeight:CGFloat! = UIApplication.sharedApplication().statusBarFrame.height
			static var tabBarHeight:CGFloat! = UITabBarController().tabBar.frame.height
			static var tabBarViewHeight:CGFloat! = navViewHeight - tabBarHeight
		}
		static var activityNames:[String] = ["Active", "Artist", "Badass", "Brainy", "Caring", "Chill", "Creative", "Cultured", "Curious", "Driven", "Easygoing", "Empathetic", "Experienced", "Extroverted", "Fashionable", "Fit", "Free Spirited", "Friendly", "Fun", "Funky", "Hipster", "Introverted", "LOL", "Loud", "Modern", "Motivated", "Observant", "Ol'Skool", "Open Minded", "Outgoing", "Posh", "Rebellious", "Relaxed", "Romantic", "Rustic", "Sarcastic", "Serious", "Sporty", "Studious", "Thrilling", "Tough", "Traditional", "Trustworthy", "Visual", "Weird"]
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