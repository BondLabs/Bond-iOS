//
//  CustomTactileButton.swift
//  Bond
//
//  Created by Bond on 2/10/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

import UIKit

class CustomTactileButton: UIButton {

	var hasTactileFeedback:Bool! = false
	var normalBgColor:UIColor!
	var normalTxtColor:UIColor!
	var tappedBgColor:UIColor!
	var tappedTxtColor:UIColor!
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		if (hasTactileFeedback == true) {
			self.setBackgroundImage(AppData.util.UIImageFromColor(tappedBgColor), forState: UIControlState.Normal)
			self.setTitleColor(tappedTxtColor, forState: UIControlState.Normal)
		}
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		if (hasTactileFeedback == true) {
			self.setBackgroundImage(AppData.util.UIImageFromColor(normalBgColor), forState: UIControlState.Normal)
			self.setTitleColor(normalTxtColor, forState: UIControlState.Normal)
		}
	}

	func setNormal(background: UIColor, text: UIColor) {
		self.normalBgColor = background
		self.normalTxtColor = text
		self.backgroundColor = UIColor.clearColor()
		self.setBackgroundImage(AppData.util.UIImageFromColor(background), forState: UIControlState.Normal)
		self.setTitleColor(text, forState: UIControlState.Normal)
	}
	
	func setTapped(background: UIColor, text: UIColor) {
		self.tappedBgColor = background
		self.tappedTxtColor = text
		self.backgroundColor = UIColor.clearColor()
		self.setBackgroundImage(AppData.util.UIImageFromColor(background), forState: UIControlState.Normal)
		self.setTitleColor(text, forState: UIControlState.Normal)
	}
	
}