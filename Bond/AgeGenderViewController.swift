//
//  AgeGenderViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 1/9/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class AgeGenderViewController: UIViewController {
	@IBOutlet var descLabel: UILabel!
	@IBOutlet var male: CustomSegmentedButton!
	@IBOutlet var female: CustomSegmentedButton!
	@IBOutlet var next: UIButton!

	override func viewDidLoad() {
		// Set up basic view properties
		self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)

		// Set up view description label
		descLabel.text = "Let's get some basics"
		descLabel.numberOfLines = 1
		descLabel.sizeToFit()
		descLabel.textColor = UIColor.whiteColor()
		descLabel.center = CGPointMake(self.view.frame.width/2, self.view.frame.height / 10)
		descLabel.font = UIFont(name: "Helvetica-Neue", size: 18.0)
		self.view.addSubview(descLabel)

		// Set up gender selectors
		male.setup()
		male.frame.size = CGSizeMake(self.view.frame.width / 2 - 10, 40)
		male.frame.origin = CGPointMake(10, self.view.frame.height / 6)
		male.setTitle("Male", forState: UIControlState.Normal)
		male.select()

		female.setup()
		female.frame.size = CGSizeMake(self.view.frame.width / 2 - 10, 40)
		female.frame.origin = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 6)
		female.setTitle("Female", forState: UIControlState.Normal)
		female.deselect()

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 85)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next", forState: UIControlState.Normal)
		next.titleLabel?.font = UIFont(name: "Helvetica-Neue", size: 18.0)
	}

	@IBAction func maleTapped(sender: AnyObject) {
		if (male.backgroundColor == UIColor.whiteColor()) {
			male.select()
			female.deselect()
		}
	}

	@IBAction func femaleTapped(sender: AnyObject) {
		if (female.backgroundColor == UIColor.whiteColor()) {
			female.select()
			male.deselect()
		}
	}
}