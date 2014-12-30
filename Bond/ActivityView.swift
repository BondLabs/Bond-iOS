//
//  ActivityView.swift
//  Bond
//
//  Created by Kevin Zhang on 12/25/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class ActivityView: UIView {
    
    var nameLabel:UILabel!
    var iconView:CustomImageView!
    
    func setup(name: String) {
        // Bounds of view
        var viewSize = self.frame.size
        
        // Set background to clear
        self.backgroundColor = UIColor.clearColor()
        
        // Set up label for the name of the activity
        nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont.systemFontOfSize(14.0)
        nameLabel.sizeToFit()
        nameLabel.center = CGPointMake(viewSize.width / 2, viewSize.width + (viewSize.height - viewSize.width) / 2)
        self.addSubview(nameLabel)
        
        // Set up iconView
        iconView = CustomImageView()
        iconView.frame.size = CGSizeMake(viewSize.width, viewSize.width)
        // Set image frame to 1 down from center to prevent the top of the view from being cut off
        iconView.center = CGPointMake(viewSize.width / 2, viewSize.width / 2 + 1)
        iconView.performSetup(40.0)
        self.addSubview(iconView)
    }
    
    func addToggle() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toggle"))
    }
    
    func toggle() {
        self.iconView.toggleColors()
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