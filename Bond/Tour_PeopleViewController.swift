//
//  Tour_PeopleViewController.swift
//  Bond
//
//  Created by Bond on 1/31/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class Tour_PeopleViewController: UIViewController {

    func setup(frame: CGRect) {
        self.view.frame = frame
        
        // Set up icon
        var icon = CircleImageView()
        icon.frame.size = CGSizeMake(125, 125)
        icon.setDefaultImage(UIImage(named: "Tour_2.png")!)
        icon.addBorder(0xFFFFFF)
        icon.untappedBackground = AppData.util.UIColorFromRGB(0x00A4FF)
        icon.performSetup(0.6)
        icon.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 3)
        self.view.addSubview(icon)
        
        // Set up name label
        var nameLabel = UILabel()
        nameLabel.text = "People"
        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 29.0)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        nameLabel.numberOfLines = 0
        nameLabel.center = CGPointMake(self.view.frame.width / 2, 300)
        self.view.addSubview(nameLabel)
        
        // Set up label
        var descLabel = UILabel()
        descLabel.text = "Meeting people is one of life’s great \n pleasures, using ninjas we determine \n the people you should meet."
        descLabel.textAlignment = NSTextAlignment.Center
        descLabel.font = UIFont(name: "Avenir-Book", size: 14.0)
        descLabel.textColor = UIColor.whiteColor()
        descLabel.numberOfLines = 3
        descLabel.sizeToFit()
        descLabel.center = CGPointMake(self.view.frame.width / 2, 400)
        self.view.addSubview(descLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
