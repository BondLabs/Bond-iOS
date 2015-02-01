//
//  Tour_ChatViewController.swift
//  Bond
//
//  Created by Bond on 1/31/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class Tour_ChatViewController: UIViewController {

    func setup(frame: CGRect) {
        self.view.frame = frame
        
        // Set up icon
        var icon = CircleImageView()
        icon.frame.size = CGSizeMake(125, 125)
        icon.setDefaultImage(UIImage(named: "Tour_5.png")!)
        icon.addBorder(0xFFFFFF)
        icon.untappedBackground = AppData.util.UIColorFromRGB(0x00A4FF)
        icon.performSetup(0.6)
        icon.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 3)
        self.view.addSubview(icon)
        
        // Set up name label
        var nameLabel = UILabel()
        nameLabel.text = "Chat"
        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 29.0)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        nameLabel.numberOfLines = 0
        nameLabel.center = CGPointMake(self.view.frame.width / 2, 300)
        self.view.addSubview(nameLabel)
        
        // Set up label
        var descLabel = UILabel()
        descLabel.text = "Once you get a Bond, it can be tricky to \n find your new friend. Simply start a quick \n conversation to find a place to meet."
        descLabel.textAlignment = NSTextAlignment.Center
        descLabel.font = UIFont(name: "Avenir-Book", size: 14.0)
        descLabel.textColor = UIColor.whiteColor()
        descLabel.numberOfLines = 4
        descLabel.sizeToFit()
        descLabel.center = CGPointMake(self.view.frame.width / 2, 400)
        self.view.addSubview(descLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
