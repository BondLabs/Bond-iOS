//
//  CustomButton.swift
//  Bond
//
//  Created by Kevin Zhang on 1/9/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class CustomSegmentedButton: UIButton {

	func setup() {
		self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
		self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
		self.titleLabel?.font = UIFont(name: "Helvetica-Neue", size: 16.5)
	}

	func select() {
		self.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
	}

	func deselect() {
		self.backgroundColor = UIColor.whiteColor()
		self.setTitleColor(AppData.util.UIColorFromRGB(0x00A4FF), forState: UIControlState.Normal)
	}

}
