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
	@IBOutlet var single: CustomSegmentedButton!
	@IBOutlet var taken: CustomSegmentedButton!
	@IBOutlet var next: UIButton!
	var divider1:UIView!
	var divider2:UIView!

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
		male.deselect()
		female.setup()
		female.frame.size = CGSizeMake(self.view.frame.width / 2 - 10, 40)
		female.frame.origin = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 6)
		female.setTitle("Female", forState: UIControlState.Normal)
		female.deselect()
		divider1 = UIView()
		divider1.backgroundColor = UIColor.whiteColor()
		divider1.frame.size = CGSizeMake(2, 30)
		divider1.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 6 + 20)
		divider1.layer.cornerRadius = 0.25
		self.view.addSubview(divider1)

		// Set up relationship selectors
		single.setup()
		single.frame.size = CGSizeMake(self.view.frame.width / 2 - 10, 40)
		single.frame.origin = CGPointMake(10, self.view.frame.height / 6 + 50)
		single.setTitle("Single", forState: UIControlState.Normal)
		single.deselect()
		taken.setup()
		taken.frame.size = CGSizeMake(self.view.frame.width / 2 - 10, 40)
		taken.frame.origin = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 6 + 50)
		taken.setTitle("In a Relationship", forState: UIControlState.Normal)
		taken.deselect()
		divider2 = UIView()
		divider2.backgroundColor = UIColor.whiteColor()
		divider2.frame.size = CGSizeMake(2, 30)
		divider2.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 6 + 70)
		divider2.layer.cornerRadius = 0.25
		self.view.addSubview(divider2)

		// Set up next button
		next.frame.size = CGSizeMake(self.view.frame.width, 50)
		next.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 85)
		next.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		next.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		next.setTitle("Next 〉", forState: UIControlState.Normal)
		next.titleLabel?.font = UIFont(name: "Helvetica-Neue", size: 18.0)
	}

	@IBAction func maleTapped(sender: AnyObject) {
		if (male.active == false) {
			UIView.animateWithDuration(0.15, animations: {
				self.male.select()
				self.female.deselect()
				self.divider1.alpha = 0.0
			})
		} else {
			UIView.animateWithDuration(0.15, animations: {
				self.male.deselect()
				self.divider1.alpha = 1.0
			})
		}
	}

	@IBAction func femaleTapped(sender: AnyObject) {
		if (female.active == false) {
			UIView.animateWithDuration(0.15, animations: {
				self.female.select()
				self.male.deselect()
				self.divider1.alpha = 0.0
			})
		} else {
			UIView.animateWithDuration(0.15, animations: {
				self.female.deselect()
				self.divider1.alpha = 1.0
			})
		}
	}

	@IBAction func singleTapped(sender: AnyObject) {
		if (single.active == false) {
			UIView.animateWithDuration(0.15, animations: {
				self.single.select()
				self.taken.deselect()
				self.divider2.alpha = 0.0
			})
		} else {
			UIView.animateWithDuration(0.15, animations: {
				self.single.deselect()
				self.divider2.alpha = 1.0
			})
		}
	}

	@IBAction func takenTapped(sender: AnyObject) {
		if (taken.active == false) {
			UIView.animateWithDuration(0.15, animations: {
				self.taken.select()
				self.single.deselect()
				self.divider2.alpha = 0.0
			})
		} else {
			UIView.animateWithDuration(0.15, animations: {
				self.taken.deselect()
				self.divider2.alpha = 1.0
			})
		}
	}
}