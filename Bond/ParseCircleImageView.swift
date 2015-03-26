//
//  ParseCircleImageView.swift
//  Bond
//
//  Created by Bryce Dougherty on 3/25/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

import UIKit

class ParseCircleImageView: PFImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

	var selected:Bool! = false
	var scaleFactor:CGFloat!
	var untappedBackground:UIColor! = AppData.util.UIColorFromRGB(0x00A4FF)
	var tappedBackground:UIColor! = AppData.util.UIColorFromRGB(0xFFFFFF)

	/* * *
	* * * Functions to set up the imageview------------------------------------
	* * */

	// Store icons


	// Initial setup of the view
	func performSetup(scale: CGFloat) {
		// Store scale
		self.scaleFactor = scale

		// Set view up
		self.contentMode = UIViewContentMode.Center
		

		// Turn the frame into a circle
		self.layer.cornerRadius = self.frame.width / 2

		// Set up image

	}

	// Refresh the image


	/* * *
	* * * Utility functions to customize the view------------------------------
	* * */

	// Store default image name

	// Add a border to the view
	func addBorder(color: UInt) {
		self.layer.borderWidth = 1.0
		self.layer.borderColor = AppData.util.UIColorFromRGB(color).CGColor
	}

	/* * *
	* * * Utility functions for if the image needs to be toggle-able-----------
	* * */





}
