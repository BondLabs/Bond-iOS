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
        var screenSize:CGSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
        
        // Initialize background image
        let unscaledBg = UIImage(named: "bg@2x.png")!
        UIGraphicsBeginImageContextWithOptions(screenSize, false, 0.0)
        unscaledBg.drawInRect(CGRect(origin: CGPointZero, size: screenSize))
        var bgImage = UIImageView()
        bgImage.image = UIGraphicsGetImageFromCurrentImageContext()
        bgImage.sizeToFit()
        bgImage.center = CGPointMake(screenSize.width / 2, screenSize.height / 2)
        UIGraphicsEndImageContext()
        self.view.addSubview(bgImage)
		
        // Initialize logo image
        let unscaledLogo = UIImage(named: "Logo.png")!
        var logoSize = CGSizeMake(screenSize.width * 0.75, screenSize.width * 0.75 * unscaledLogo.size.height / unscaledLogo.size.width)
        UIGraphicsBeginImageContextWithOptions(logoSize, false, 0.0)
        unscaledLogo.drawInRect(CGRect(origin: CGPointZero, size: logoSize))
        var logoImage = UIImageView()
        logoImage.image = UIGraphicsGetImageFromCurrentImageContext()
        logoImage.sizeToFit()
        logoImage.center = CGPointMake(screenSize.width / 2, screenSize.height * 0.25)
        UIGraphicsEndImageContext()
        self.view.addSubview(logoImage)
        
        // Initialize description label
        var descLabel = UILabel()
        descLabel.text = "Experience new human connection \n with people all around you."
        descLabel.numberOfLines = 2
        descLabel.textColor = AppData.util.UIColorFromRGB(0xFFFFFF)
        descLabel.textAlignment = NSTextAlignment.Center
        descLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height / 10)
        descLabel.center = CGPointMake(screenSize.width / 2, screenSize.height * 0.65)
        self.view.addSubview(descLabel)
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.navigationController?.navigationBarHidden = false
        super.prepareForSegue(segue, sender: sender)
    }
}