//
//  ActivityView.swift
//  Bond
//
//  Created by Kevin Zhang on 12/25/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class ActivityView: UIView {
    
    /*
     * Use to create an Activity view.
     * setup(name) creates an activity view with the relevant name.
     * addToggle() is used to create a tappable view
     * Returns a view; the view still must be positioned.
     */
    
    // View properties
    var nameLabel:UILabel!
    var iconView:CircleImageView!
    
    /* * *
     * * * Set up functions-----------------------------------------------------
     * * */
    
    // Set up
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
        iconView = CircleImageView()
        iconView.addBorder(0x00A4FF)
        iconView.frame.size = CGSizeMake(viewSize.width, viewSize.width)
        // Set image frame to 1 down from center to prevent the top of the view from being cut off
        iconView.center = CGPointMake(viewSize.width / 2, viewSize.width / 2 + 1)
        iconView.performSetup(40.0)
        self.addSubview(iconView)
    }
    
    /* * *
     * * * Toggle functions, use only if activityview needs to be toggle-able---
     * * */
    
    // Add a gesture recognizer
    func addToggle() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toggle"))
    }
    
    // Toggle the colors
    func toggle() {
        self.iconView.toggleColors()
    }
    
}