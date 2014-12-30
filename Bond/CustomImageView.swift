//
//  CustomImageView.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var selected:Bool! = false
    var inset:CGFloat!
    
    // Store icon names
    var untappedIcon:String! = "Profile(i).png"
    var tappedIcon:String! = "Profile(a).png"

    func performSetup(edge: CGFloat) {
        // Store inset
        self.inset = edge
        
        // Set view up
        self.contentMode = UIViewContentMode.Center
        self.backgroundColor = self.UIColorFromRGB(0x00A4FF)
        self.layer.borderColor = self.UIColorFromRGB(0x00A4FF).CGColor
        
        // Border width
        self.layer.borderWidth = 3.0
        // Turn the frame into a circle
        self.layer.cornerRadius = self.frame.width / 2
        
        // Set up image
        self.refreshImage()
    }
    
    func refreshImage() {
        var imageNameToUse:String!
        if (selected == false) {
            imageNameToUse = untappedIcon
        } else {
            imageNameToUse = tappedIcon
        }
        var icon = UIImage(named: imageNameToUse)!
        var viewSize = CGSizeMake(self.frame.width, self.frame.height)
        var smallSize = CGSizeMake(viewSize.width - inset, viewSize.height - inset)
        UIGraphicsBeginImageContextWithOptions(smallSize, false, 0.0)
        icon.drawInRect(CGRect(origin: CGPointZero, size: smallSize))
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func setUntapped() {
        self.selected = false
        self.backgroundColor = self.UIColorFromRGB(0x00A4FF)
        self.refreshImage()
    }
    
    func setTapped() {
        self.selected = true
        self.backgroundColor = self.UIColorFromRGB(0xFFFFFF)
        self.refreshImage()
    }
    
    func toggleColors() {
        if (selected == true) {
            self.setUntapped()
        } else {
            self.setTapped()
        }
    }
    
    // RGB to UIColor converter
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
