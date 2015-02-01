//
//  StartViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class Tour_StartViewController: UIViewController {
    
    /* * *
     * * * Set up the view------------------------------------------------------
     * * */
    
    override func viewDidLoad() {
        
        /* * *
         * * * Do basic setup---------------------------------------------------
         * * */
		
        // Store screen dimensions
        var screenSize:CGSize = CGSizeMake(self.view.frame.width, self.view.frame.height - 86)
		
        // Initialize logo image
        /*let unscaledLogo = UIImage(named: "Logo.png")!
        var logoSize = CGSizeMake(screenSize.width * 0.75, screenSize.width * 0.75 * unscaledLogo.size.height / unscaledLogo.size.width)
        UIGraphicsBeginImageContextWithOptions(logoSize, false, 0.0)
        unscaledLogo.drawInRect(CGRect(origin: CGPointZero, size: logoSize))
        var logoImage = UIImageView()
        logoImage.image = UIGraphicsGetImageFromCurrentImageContext()
        logoImage.sizeToFit()
        logoImage.center = CGPointMake(screenSize.width / 2, screenSize.height * 0.25)
        UIGraphicsEndImageContext()
        self.view.addSubview(logoImage)*/
        var icon = CircleImageView()
        icon.frame.size = CGSizeMake(125, 125)
        icon.setDefaultImage(UIImage(named: "Tour_1.png")!)
        icon.addBorder(0xFFFFFF)
        icon.untappedBackground = AppData.util.UIColorFromRGB(0x00A4FF)
        icon.performSetup(0.6)
        icon.center = CGPointMake(self.view.frame.width / 2, screenSize.height / 3)
        self.view.addSubview(icon)
        
        // Set up name label
        var nameLabel = UILabel()
        nameLabel.text = "Start"
        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 29.0)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        nameLabel.numberOfLines = 0
        nameLabel.center = CGPointMake(self.view.frame.width / 2, 300)
        self.view.addSubview(nameLabel)
        
        // Initialize description label
        var descLabel = UILabel()
        descLabel.text = "Experience new human connection \n with people all around you."
        descLabel.textAlignment = NSTextAlignment.Center
        descLabel.font = UIFont(name: "Avenir-Book", size: 14.0)
        descLabel.textColor = UIColor.whiteColor()
        descLabel.numberOfLines = 2
        descLabel.sizeToFit()
        descLabel.center = CGPointMake(self.view.frame.width / 2, 400)
        self.view.addSubview(descLabel)
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.navigationController?.navigationBarHidden = false
        super.prepareForSegue(segue, sender: sender)
    }
}