//
//  CustomImageView.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
	
	/*
	* Initialize a circle view.
	* Call performSetup(edge) to create a image with inset of value edge
	* Use refreshImage() to store the relevant image
	* Other functions are utility functions.
	* This only returns a UIImageView; frame setup still has to be done.
	*/
	
	var selected:Bool! = false
	var scaleFactor:CGFloat!
	var untappedBackground:UIColor! = AppData.util.UIColorFromRGB(0x00A4FF)
	var tappedBackground:UIColor! = AppData.util.UIColorFromRGB(0xFFFFFF)
	
	/* * *
	* * * Functions to set up the imageview------------------------------------
	* * */
	
	// Store icons
	var untappedIcon:UIImage! = UIImage(named: "Profile(i).png")
	var tappedIcon:UIImage! = UIImage(named: "Profile(a).png")
	
	// Initial setup of the view
	func performSetup(scale: CGFloat) {
		// Store scale
		self.scaleFactor = scale
		
		// Set view up
		self.contentMode = UIViewContentMode.Center
		self.backgroundColor = self.untappedBackground
		
		// Turn the frame into a circle
		self.layer.cornerRadius = self.frame.width / 2
		
		// Set up image
		self.refreshImage()
	}
	
	// Refresh the image
	func refreshImage() {
		var icon:UIImage!
		if (selected == false) {
			icon = untappedIcon
		} else {
			icon = tappedIcon
		}
		var viewSize = CGSizeMake(icon.size.width, icon.size.height)
		var smallSize = CGSizeMake(viewSize.width * scaleFactor, viewSize.height * scaleFactor)
		UIGraphicsBeginImageContextWithOptions(smallSize, false, 0.0)
		icon.drawInRect(CGRect(origin: CGPointZero, size: smallSize))
		self.image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
	}
	
	/* * *
	* * * Utility functions to customize the view------------------------------
	* * */
	
	// Store default image name
	func setDefaultImage(file: UIImage) {
		self.untappedIcon = file
	}
	
	// Store tapped image name
	func setTappedImage(file: UIImage) {
		self.tappedIcon = file
	}
	
	// Add a border to the view
	func addBorder(color: UInt) {
		self.layer.borderWidth = 3.0
		self.layer.borderColor = AppData.util.UIColorFromRGB(color).CGColor
	}
	
	/* * *
	* * * Utility functions for if the image needs to be toggle-able-----------
	* * */
	
	func setUntapped() {
		self.selected = false
		self.backgroundColor = self.untappedBackground
		self.refreshImage()
	}
	
	func setTapped() {
		self.selected = true
		self.backgroundColor = self.tappedBackground
		self.refreshImage()
	}
	
	func toggleColors() {
		if (selected == true) {
			self.setUntapped()
		} else {
			self.setTapped()
		}
	}
	
}
