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
    @IBOutlet var signUpButton: BlurredButton!
    @IBOutlet var loginButton: UIButton!
    
    /* * *
     * * * Set up the view------------------------------------------------------
     * * */
    
    override func viewDidLoad() {
        
        /* * *
         * * * Do basic setup---------------------------------------------------
         * * */
		//var bgImage = UIImageView(frame: self.view.frame)
		
        // Hide navigation bar
		self.navigationController?.navigationBarHidden = true

        // Store screen dimensions
        let screenSize:CGSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
        
        // Initialize background image
        let unscaledBg = UIImage(named: "bg@2x.png")!
        UIGraphicsBeginImageContextWithOptions(screenSize, false, 0.0)
        unscaledBg.drawInRect(CGRect(origin: CGPointZero, size: screenSize))
        bgImage.image = UIGraphicsGetImageFromCurrentImageContext()
        bgImage.sizeToFit()
        bgImage.center = CGPointMake(screenSize.width / 2, screenSize.height / 2)
        UIGraphicsEndImageContext()

		bgImage = UIImageView()
		
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
        descLabel.textColor = AppData.util.UIColorFromRGB(0xFFFFFF)
        descLabel.textAlignment = NSTextAlignment.Center
        descLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height / 10)
        descLabel.center = CGPointMake(screenSize.width / 2, screenSize.height * 0.65)
		
		//var blurEffect = UIBlurEffect(style: .Dark)
		//var visualEffectView = UIVisualEffectView(effect: blurEffect) as UIVisualEffectView
		
		
		//signUpButton.blurView = visualEffectView
        // Initialize signup button
		signUpButton.backgroundColor = AppData.util.UIColorFromRGBA(0x00A4FF, alphaValue: 1.0)
		
		
        signUpButton.frame = CGRectMake(0, screenSize.height - screenSize.width * 2 / 15, screenSize.width / 2, screenSize.width * 2 / 15)
		
		signUpButton.blurView.frame = signUpButton.bounds
		signUpButton.blurView.tintColor = AppData.util.UIColorFromRGB(0x00A4FF)
		signUpButton.blurView.userInteractionEnabled = false
		
		signUpButton.blurView.addSubview(signUpButton.titleLabel!)
		
		signUpButton.addSubview(signUpButton.blurView)
        signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
		
		
        // Initialize login button
        loginButton.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
        loginButton.setTitle("Log In", forState: UIControlState.Normal)
        loginButton.frame = CGRectMake(screenSize.width / 2, screenSize.height - screenSize.width * 2 / 15, screenSize.width / 2, screenSize.width * 2 / 15)
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.navigationController?.navigationBarHidden = false
        super.prepareForSegue(segue, sender: sender)
    }

	@IBAction func signUpTouched(sender: BlurredButton) {
		//sender.backgroundColor = AppData.util.UIColorFromRGB(0x0094E6)
		sender.blurView.tintColor = AppData.util.UIColorFromRGB(0x0094E6)
	}

	@IBAction func signUpReleased(sender: BlurredButton) {
		//sender.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		sender.blurView.tintColor = AppData.util.UIColorFromRGB(0x00A4FF)
	}

	@IBAction func loginTouched(sender: UIButton) {
		sender.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
	}

	@IBAction func loginReleased(sender: UIButton) {
		sender.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
	}
}