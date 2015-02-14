//
//  CustomTextField.swift
//  Bond
//
//  Created by Kevin Zhang on 12/23/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {

	/*
	* Use to create a custom text field.
	* Only returns a text field; still needs to be positioned.
	*/

	/* * *
	* * * Initial setup--------------------------------------------------------
	* * */

	required init(coder aDecoder: NSCoder) {
		NSLog("%@", aDecoder)
		super.init(coder: aDecoder)

		self.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
		self.textColor = UIColor.whiteColor()
		self.layer.borderColor = UIColor.whiteColor().CGColor
		self.font = UIFont(name: "Avenir-Book", size: 16.5)
	}

	/* * *
	* * * Use to customize text field------------------------------------------
	* * */

	override func textRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, 10, 0)
	}

	override func editingRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, 10, 0)
	}

	func setPlaceholder(placeholderText: String) {
		self.attributedPlaceholder = NSAttributedString(string:placeholderText,
			attributes:[NSForegroundColorAttributeName: AppData.util.UIColorFromRGB(0x6E6E6E)])
	}

	func textFieldShouldEndEditing(field: UITextField) -> Bool {

		let fieldText: String = field.text
		if (field.tag == SignUpViewController.textFieldType.phoneNumber) {

			let regexString = "(?:(?:(\\s*\\(\\?([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\s*)|([2-9]1[02-9]|[2‌​-9][02-8]1|[2-9][02-8][02-9]))\\)?\\s*(?:[.-]\\s*)?)([2-9]1[02-9]|[2-9][02-9]1|[2-9]‌​[02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})"

			let regex: NSRegularExpression = NSRegularExpression(pattern: regexString, options: .CaseInsensitive, error: nil)!


			let matches = regex.matchesInString(fieldText, options: nil, range: NSMakeRange(0, countElements(fieldText)))

			bondLog("text view matches:")
			if matches.count > 0 {
			let alert = UIAlertView(title: "Oops", message: "Please input a valid phone number", delegate: nil, cancelButtonTitle: "Okay")
			alert.show()
			}
			return matches.count > 0
		}
		else {
			return true
		}
	}
}