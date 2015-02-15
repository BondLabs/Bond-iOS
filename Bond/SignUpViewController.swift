//
//  SignUpViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

var signUpPhoneNumberIsOkay = false


class SignUpViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate {

	/* * *
	* * * View properties------------------------------------------------------
	* * */


	struct textFieldType {
		static let firstName = 0x6669727374			//Literally hexidecimal for "first"
		static let lastName = 0x6c617374			//Literally hexidecimal for "last"
		static let phoneNumber = 0x70686f6e65		//Literally hexidecimal for "phone"
		static let password = 0x70617373776f7264	//Literally hexidecimal for "password"
	}


	var selectedField:UITextField!
	var keyboardHeight:CGFloat!
	var viewHeight:CGFloat!
	var errorStatesLabel = UILabel()
	var errorStatesLabelDictionary = NSMutableDictionary()


	@IBOutlet var descLabel: UILabel!
	@IBOutlet var firstName: CustomTextField!
	@IBOutlet var lastName: CustomTextField!
	@IBOutlet var phoneNumber: CustomTextField!
	@IBOutlet var password: CustomTextField!
	@IBOutlet var nextButton: UIButton!
	@IBOutlet var doneButton: UIButton!

	/* * *
	* * * Set up the view------------------------------------------------------
	* * */

	override func viewDidLoad() {
		super.viewDidLoad()

		ViewManager.sharedInstance.currentViewController = self
		// Store frame data
		viewHeight = self.view.frame.height - AppData.data.heights.navBarHeight - AppData.data.heights.statusBarHeight

		// Set delegates
		firstName.delegate = self
		lastName.delegate = self
		phoneNumber.delegate = self
		password.delegate = self

		self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

		// Set up buttons
		self.nextButton.alpha = 0.0
		self.nextButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
		self.nextButton.setTitle("Next 〉", forState: UIControlState.Normal)
		self.nextButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)
		self.nextButton.addTarget(self, action: "buttonTouchedDown:", forControlEvents: UIControlEvents.TouchDown)
		// self.nextButton.buttonType = UIButtonType.DetailDisclosure
		self.view.bringSubviewToFront(nextButton)
		self.doneButton.alpha = 0.0
		self.doneButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)

		self.doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		self.doneButton.setTitle("Done 〉", forState: UIControlState.Normal)
		self.doneButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)
		self.doneButton.addTarget(self, action: "buttonTouchedDown:", forControlEvents: UIControlEvents.TouchDown)
		self.view.bringSubviewToFront(doneButton)

		// Add keyboard selectors
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)

		// Set up navigation controller properties
		//self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
		self.view.backgroundColor = UIColor.bl_backgroundColorColor()
		// Set up instructions label
		self.descLabel.textColor = UIColor.bl_doveGrayColor()
		self.descLabel.font = UIFont(name: "Helvetica-Neue", size: 18.0)
		self.descLabel.numberOfLines = 0
		self.descLabel.sizeToFit()
		self.descLabel.center = CGPointMake(self.view.frame.width / 2, 50)

		// Set up firstName and lastName fields
		self.firstName.setPlaceholder("First")
		self.firstName.backgroundColor = UIColor.whiteColor()
		self.firstName.textColor = UIColor.bl_silverChaliceColor()
		self.firstName.frame = CGRectMake(10, 135, self.view.frame.width / 2 - 15, 40)
		self.firstName.tag = SignUpViewController.textFieldType.firstName

		self.lastName.setPlaceholder("Last")
		self.lastName.frame = CGRectMake(self.view.frame.width / 2 + 5, 135, self.view.frame.width / 2 - 15, 40)
		self.lastName.backgroundColor = UIColor.whiteColor()
		self.lastName.textColor = UIColor.bl_silverChaliceColor()
		self.lastName.tag = SignUpViewController.textFieldType.lastName

		// Set up phoneNumber field
		self.phoneNumber.setPlaceholder("Phone number")
		self.phoneNumber.frame = CGRectMake(10, 185, self.view.frame.width - 20, 40)
		self.phoneNumber.backgroundColor = UIColor.whiteColor()
		self.phoneNumber.textColor = UIColor.bl_silverChaliceColor()
		self.phoneNumber.tag = SignUpViewController.textFieldType.phoneNumber

		// Set up password field
		self.password.setPlaceholder("Password")
		self.password.frame = CGRectMake(10, 235, self.view.frame.width - 20, 40)
		self.password.backgroundColor = UIColor.whiteColor()
		self.password.textColor = UIColor.bl_silverChaliceColor()
		self.password.tag = SignUpViewController.textFieldType.password

		// Set up agreement terms
		var agreeToTerms = UILabel()
		agreeToTerms.numberOfLines = 0
		agreeToTerms.textAlignment = NSTextAlignment.Center
		agreeToTerms.userInteractionEnabled = true
		var termsText = NSMutableAttributedString(string: "By pressing next, you hereby agree to our Terms & Conditions and \n Privacy Policy.")
		termsText.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(int: 1), range: NSMakeRange(42, 18))
		termsText.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(int: 1), range: NSMakeRange(65, 16))
		termsText.addAttribute(NSForegroundColorAttributeName, value: AppData.util.UIColorFromRGB(0xADADAD), range: NSMakeRange(0, termsText.length))
		termsText.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Book", size: 9.0)!, range: NSMakeRange(0, termsText.length))
		agreeToTerms.attributedText = termsText
		agreeToTerms.frame.size = CGSizeMake(self.view.frame.width, 30)
		agreeToTerms.center = CGPointMake(self.view.frame.width / 2, 300)
		self.view.addSubview(agreeToTerms)
		agreeToTerms.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showTerms"))



		errorStatesLabel.numberOfLines = 0
		errorStatesLabel.textAlignment = NSTextAlignment.Center
		errorStatesLabel.frame.size = CGSizeMake(self.view.frame.width - 30, 100)
		errorStatesLabel.center = CGPointMake(self.view.frame.width / 2, 375)
		errorStatesLabel.attributedText = NSAttributedString(string: "")
		self.view.addSubview(errorStatesLabel)

		// Add tap selector to resign keyboard
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
	}

	func showTerms() {
		// Eventually this code should present the website with terms and conditions
		UIApplication.sharedApplication().openURL(NSURL(string: "http://bond.sh")!)
	}

	/* * *
	* * * Customize keyboard and button animations-----------------------------
	* * */

	func hideKeyboard() {
		UIView.animateWithDuration(0.50, animations: {
			self.nextButton.frame.origin = CGPointMake(0, self.viewHeight)
			self.nextButton.alpha = 0.0
			self.doneButton.frame.origin = CGPointMake(0, self.viewHeight)
			self.doneButton.alpha = 0.0
			self.view.endEditing(true)
		})
		selectedField = nil
	}

	func textFieldDidBeginEditing(textField: UITextField) {

		if (textField.tag == SignUpViewController.textFieldType.phoneNumber) {
			signUpPhoneNumberIsOkay = false
		}

		UIView.animateWithDuration(0.25, animations: {
			self.view.frame.origin.y = AppData.data.heights.navBarHeight + AppData.data.heights.statusBarHeight - 100
		})

		let textViewsAreEmpty = (self.firstName.text == "") || (self.lastName.text == "") || (self.phoneNumber.text == "") || (self.password.text == "")

		selectedField = textField
		if (textField != password || textViewsAreEmpty) {
			self.showNextButton()
		} else {
			self.showDoneButton()
		}
		if (textField.text == "") {
			var placeholder = textField.attributedPlaceholder?.string
			textField.attributedPlaceholder = NSAttributedString(string:placeholder!,
				attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
		}
		textField.layer.borderWidth = 1.5
		textField.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
		textField.textColor = UIColor.bl_azureRadianceColor()
		if (textField.secureTextEntry) {
			textField.font = UIFont.systemFontOfSize(textField.font.pointSize)
		}
		if errorStatesLabelDictionary.allValues.count == 0 && signUpPhoneNumberIsOkay {
			self.showDoneButton()
		}
	}

	func textFieldDidEndEditing(textField: UITextField) {



		UIView.animateWithDuration(0.25, animations: {
			self.view.frame.origin.y = AppData.data.heights.navBarHeight + AppData.data.heights.statusBarHeight
		})
		var matchesRegex = true
		if (textField.tag == SignUpViewController.textFieldType.phoneNumber) {

			let regexString = "\\W*([2-9][0-8][0-9])\\W*([2-9][0-9]{2})\\W*([0-9]{4})(\\se?x?t?(\\d*))?"


			self.errorStatesLabelDictionary.removeObjectForKey("phoneNumberTaken")
			let length = countElements(textField.text)
			if (textField.text =~ regexString) && (length < 11) {
				matchesRegex = true
				errorStatesLabelDictionary.removeObjectForKey("phoneNumber")
				let characterSet = NSCharacterSet(charactersInString: "-/()\\. ")
				let phoneNumberString = phoneNumber.text.stringByTrimmingCharactersInSet(characterSet)
				UserAccountController.sharedInstance.checkIfPhoneExists(phoneNumberString)

			}
			else {
				matchesRegex = false
				signUpPhoneNumberIsOkay = false
				errorStatesLabelDictionary.setObject("Please provide a valid phone number", forKey: "phoneNumber")
			}
		}
		if (textField.tag == SignUpViewController.textFieldType.password) {
			if (countElements(textField.text) < 4 || countElements(textField.text) > 256) && textField.text != "" {
				matchesRegex = false
				errorStatesLabelDictionary.setObject("Password must be more than 4 characters", forKey: "password")
			}
			else {
				matchesRegex = true
				errorStatesLabelDictionary.removeObjectForKey("password")
			}
		}


		if !matchesRegex {

			textField.layer.borderWidth = 1.5
			textField.layer.borderColor = UIColor.redColor().CGColor
			textField.textColor = UIColor.redColor()

		}
		else if textField.text != "" {
			textField.layer.borderWidth = 1.5
			textField.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
			textField.textColor = UIColor.bl_azureRadianceColor()

		}
		else {
			textField.layer.borderWidth = 0
		}

		if (textField.text == "") {
			var placeholder = textField.attributedPlaceholder?.string
			textField.attributedPlaceholder = NSAttributedString(string:placeholder!,
				attributes:[NSForegroundColorAttributeName: AppData.util.UIColorFromRGB(0x6E6E6E)])
			textField.textColor = UIColor.bl_silverChaliceColor()
		}
		selectedField = nil

		if (textField.secureTextEntry) {
			textField.font = UIFont(name: "Avenir-Book", size: textField.font.pointSize)
		}

		self.updateErrorStateText()
		if errorStatesLabelDictionary.allValues.count == 0 && signUpPhoneNumberIsOkay {
			self.showDoneButton()
		}

	}
	/*
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
	return range.location + range.length < 10
	}
	*/
	func updateErrorStateText() {
		self.errorStatesLabel.attributedText = NSAttributedString(string: "")



		for value in self.errorStatesLabelDictionary.allValues {

			let attributedText = NSMutableAttributedString(string: self.errorStatesLabel.text! + "\n" +  (value as String))
			attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, attributedText.length))
			attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Book", size: 16.0)!, range: NSMakeRange(0, attributedText.length))
			self.errorStatesLabel.attributedText = attributedText
			self.errorStatesLabel.frame.size = CGSizeMake(self.errorStatesLabel.frame.size.width, AppData.util.getHeightForText(attributedText.string, font: UIFont(name: "Avenir-Book", size: 16.0)!, size: CGSizeMake(self.errorStatesLabel.frame.size.width, 200)).height)

			self.errorStatesLabel.numberOfLines = errorStatesLabelDictionary.allValues.count + 1

		}

		bondLog("the label says: \(self.errorStatesLabel.text)")
	}

	func buttonTouchedDown(sender: UIButton) {
		sender.backgroundColor = UIColor.bl_azureNightColor()
	}

	// Capture taps on nextButton
	@IBAction func nextButtonTapped(sender: UIButton) {
		sender.backgroundColor = UIColor.bl_azureRadianceColor()
		if (selectedField == self.firstName) {
			//self.showNextButton()
			lastName.becomeFirstResponder()
		} else if (selectedField == self.lastName) {
			//self.showNextButton()
			phoneNumber.becomeFirstResponder()
		} else if (selectedField == self.phoneNumber) {
			self.showDoneButton()
			password.becomeFirstResponder()
		}

	}

	@IBAction func doneButtonTapped(sender: UIButton) {
		sender.backgroundColor = UIColor.bl_azureRadianceColor()
		let uc = UserAccountController.sharedInstance
		if errorStatesLabelDictionary.allValues.count == 0 && signUpPhoneNumberIsOkay {
			self.performSegueWithIdentifier("nextView", sender: self)
		}

		uc.newFirstName = firstName.text
		uc.newLastName = lastName.text
		let characterSet = NSCharacterSet(charactersInString: "-/()\\. ")
		let phoneNumberString = phoneNumber.text.stringByTrimmingCharactersInSet(characterSet)
		uc.newPhoneNumber = phoneNumberString
		uc.newPassword = password.text
	}

	func showNextButton() {
		// If next button is already showing, animate reshow
		if (nextButton.alpha == 1.0) {
			UIView.animateWithDuration(0.15, animations: {
				self.nextButton.alpha = 0.5
				}, completion: { finished in
					UIView.animateWithDuration(0.15, animations: {
						self.nextButton.alpha = 1.0
					})
			})
		} else if (doneButton.alpha == 1.0) {
			// If done button is showing, animate switch
			UIView.animateWithDuration(0.3, animations: {
				self.doneButton.alpha = 0.0
				self.nextButton.alpha = 1.0
			})
		} else {
			// If neither is showing, animate show
			UIView.animateWithDuration(0.30, animations: {
				self.nextButton.alpha = 1.0
			})
		}
	}

	func showDoneButton() {


		// If done button is already showing, animate reshow
		if (doneButton.alpha == 1.0) {
			UIView.animateWithDuration(0.15, animations: {
				self.doneButton.alpha = 0.5
				}, completion: { finished in
					UIView.animateWithDuration(0.15, animations: {
						self.doneButton.alpha = 1.0
					})
			})
		} else if (nextButton.alpha == 1.0) {
			// If next button is showing, animate switch
			UIView.animateWithDuration(0.30, animations: {
				self.nextButton.alpha = 0.0
				self.doneButton.alpha = 1.0
			})
		} else {
			// If neither is showing, animate show
			UIView.animateWithDuration(0.30, animations: {
				self.doneButton.alpha = 1.0
			})
		}
	}



	func keyboardWillShow(sender: NSNotification) {
		// One time storage and setup
		if (keyboardHeight == nil) {
			self.setButtonFrames()
		}
		keyboardHeight = (sender.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().height

		UIView.animateWithDuration(0.5, animations: {
			self.nextButton.frame.origin = CGPointMake(0, AppData.data.heights.navViewHeight - self.keyboardHeight + 50)
			self.doneButton.frame.origin = CGPointMake(0, AppData.data.heights.navViewHeight - self.keyboardHeight + 50)
		})
	}

	func keyboardWillHide(sender: NSNotification) {

	}

	func setButtonFrames() {
		// Set up next button frame
		self.nextButton.frame = CGRectMake(0, viewHeight, self.view.frame.width, 50)

		// Set up done button frame
		self.doneButton.frame = CGRectMake(0, viewHeight, self.view.frame.width, 50)
	}

	/* * *
	* * * Capture segue events
	* * */

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	override func viewWillAppear(animated: Bool) {
		self.navigationController?.navigationBarHidden = false
		super.viewWillAppear(animated)
	}
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}


	override func viewWillDisappear(animated: Bool) {
		var count = self.navigationController?.viewControllers.count
		var nextVC:AnyObject? = self.navigationController?.viewControllers[count! - 1]
		if (nextVC is TourViewController) {
			self.navigationController?.navigationBarHidden = true
		}
		super.viewWillDisappear(animated)
	}
	
	
}