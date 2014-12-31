//
//  StartViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    /* * *
     * * * View properties------------------------------------------------------
     * * */
    
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    /* * *
     * * * Set up the view------------------------------------------------------
     * * */
    
    override func viewDidLoad() {
        
        /* * *
         * * * Do basic setup---------------------------------------------------
         * * */
        
        // Hide navigation bar
        self.navigationController?.navigationBarHidden = true
        
        // Store screen dimensions
        let screenSize:CGSize = UIScreen.mainScreen().bounds.size
        
        // Initialize background image
        let unscaledBg = UIImage(named: "bg@2x.png")!
        UIGraphicsBeginImageContextWithOptions(screenSize, false, 0.0)
        unscaledBg.drawInRect(CGRect(origin: CGPointZero, size: screenSize))
        bgImage.image = UIGraphicsGetImageFromCurrentImageContext()
        bgImage.sizeToFit()
        bgImage.center = CGPointMake(screenSize.width / 2, screenSize.height / 2)
        UIGraphicsEndImageContext()
        
        // Initialize logo image
        let unscaledLogo = UIImage(named: "Logo.png")!
        var logoSize = CGSizeMake(screenSize.width * 0.75, screenSize.width * 0.75 * unscaledLogo.size.height / unscaledLogo.size.width)
        UIGraphicsBeginImageContextWithOptions(logoSize, false, 0.0)
        unscaledLogo.drawInRect(CGRect(origin: CGPointZero, size: logoSize))
        logoImage.image = UIGraphicsGetImageFromCurrentImageContext()
        logoImage.sizeToFit()
        logoImage.center = CGPointMake(screenSize.width / 2, screenSize.height * 0.25)
        UIGraphicsEndImageContext()
        
        // Initialize description label
        descLabel.text = "Experience new human connection\n with people all around you."
        descLabel.numberOfLines = 2
        descLabel.textColor = self.UIColorFromRGB(0xFFFFFF)
        descLabel.textAlignment = NSTextAlignment.Center
        descLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height / 10)
        descLabel.center = CGPointMake(screenSize.width / 2, screenSize.height * 0.65)
        
        // Initialize signup button
        signUpButton.backgroundColor = self.UIColorFromRGB(0x00A4FF)
        signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
        signUpButton.frame = CGRectMake(0, screenSize.height - screenSize.width * 2 / 15, screenSize.width / 2, screenSize.width * 2 / 15)
        
        // Initialize login button
        loginButton.backgroundColor = self.UIColorFromRGB(0x4A4A4A)
        loginButton.setTitle("Log In", forState: UIControlState.Normal)
        loginButton.frame = CGRectMake(screenSize.width / 2, screenSize.height - screenSize.width * 2 / 15, screenSize.width / 2, screenSize.width * 2 / 15)
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
        super.prepareForSegue(segue, sender: sender)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}