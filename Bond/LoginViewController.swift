//
//  LoginViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {



	struct textFieldType {
		static let phoneNumber = 0x70686f6e65		//Literally hexidecimal for "phone"
		static let password = 0x70617373776f7264	//Literally hexidecimal for "password"
	}

    
    /* * *
     * * * View properties------------------------------------------------------
     * * */
    
    var viewSize:CGSize!
    var keyboardHeight:CGFloat!
    var barHeight:CGFloat!
	var errorStatesLabel = UILabel()
	var errorStatesLabelDictionary = NSMutableDictionary()
    
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    /* * *
     * * * Set up the view------------------------------------------------------
     * * */
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		
		ViewManager.sharedInstance.currentViewController = self
        /* * *
         * * * Do basic setup---------------------------------------------------
         * * */
        
        // Store size of screen
        var barHeight = self.navigationController?.navigationBar.bounds.height
        viewSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - barHeight!)

		
        
        // Set delegates
        phoneNumber.delegate = self
        password.delegate = self
        
        // Set up login button
        self.loginButton.alpha = 0.0
        self.loginButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.loginButton.setTitle("Log In", forState: UIControlState.Normal)
		self.loginButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)
		self.loginButton.addTarget(self, action: "buttonTouchedDown:", forControlEvents: UIControlEvents.TouchDown)
        
        // Add keyboard selectors
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillShowNotification, object: nil)
        
        // Set up navigation controller properties
		//self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
		self.view.backgroundColor = UIColor.bl_backgroundColorColor()
        self.navigationController?.navigationBarHidden = false

		self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
		//self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
        self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        // Set up instructions label
        self.descLabel.textColor = UIColor.bl_doveGrayColor()
        self.descLabel.center = CGPointMake(viewSize.width / 2, viewSize.height / 12)
        self.descLabel.text = "Welcome Back!"
        
        // Set up phoneNumber field
        self.phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: UIColor.bl_silverChaliceColor()])
        self.phoneNumber.frame = CGRectMake(10, viewSize.height * 10/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
		// self.phoneNumber.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
		self.phoneNumber.backgroundColor = UIColor.whiteColor()
		//self.phoneNumber.textColor = AppData.util.UIColorFromRGB(0x6E6E6E)
		self.phoneNumber.textColor = UIColor.bl_silverChaliceColor()

		self.phoneNumber.tag = textFieldType.phoneNumber
		//self.phoneNumber.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
		//self.phoneNumber.layer.borderWidth = 1.5
        
        // Set up password field
        self.password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.bl_silverChaliceColor()])
        self.password.frame = CGRectMake(10, viewSize.height * 15/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
		self.password.backgroundColor = UIColor.whiteColor()
		self.password.textColor = UIColor.bl_silverChaliceColor()

		self.password.tag = textFieldType.password
		
		// Set up agreement terms
		var forgotPW = UILabel()
		forgotPW.numberOfLines = 0
		forgotPW.textAlignment = NSTextAlignment.Center
		forgotPW.userInteractionEnabled = true
		var forgotText = NSMutableAttributedString(string: "Forgot Password?")
		//forgotText.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(int: 1), range: NSMakeRange(42, 18))
		//forgotText.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(int: 1), range: NSMakeRange(65, 16))
		forgotText.addAttribute(NSForegroundColorAttributeName, value: AppData.util.UIColorFromRGB(0xADADAD), range: NSMakeRange(0, forgotText.length))
		forgotText.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Book", size: 9.0)!, range: NSMakeRange(0, forgotText.length))
		forgotPW.attributedText = forgotText
		forgotPW.frame.size = CGSizeMake(self.view.frame.width, 30)
		forgotPW.center = CGPointMake(self.view.frame.width / 2, 300)
		self.view.addSubview(forgotPW)
		forgotPW.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showForgotPW"))
		
        // Add tap selector to resign keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))


		errorStatesLabel.numberOfLines = 0
		errorStatesLabel.textAlignment = NSTextAlignment.Center
		errorStatesLabel.frame.size = CGSizeMake(self.view.frame.width - 30, 100)
		errorStatesLabel.center = CGPointMake(self.view.frame.width / 2, 250)
		errorStatesLabel.attributedText = NSAttributedString(string: "")
		self.view.addSubview(errorStatesLabel)
    }
	
	func showForgotPW() {
		// Eventually this code should present the website with terms and conditions
		UIApplication.sharedApplication().openURL(NSURL(string: "http://bond.sh")!)
	}
    
    /* * *
     * * * Customize keyboard and button animations-----------------------------
     * * */
    
    func hideKeyboard() {
        UIView.animateWithDuration(0.5, animations: {
            self.loginButton.frame.origin = CGPointMake(0, self.viewSize!.height)
            self.loginButton.alpha = 0.0
            self.view.endEditing(true)
        })
    }
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
    func textFieldDidBeginEditing(textField: UITextField) {
        self.showButton()
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
    }

	func textFieldDidEndEditing(textField: UITextField) {
		//textField.layer.borderWidth = 0


		var matchesRegex = true
		if (textField.tag == SignUpViewController.textFieldType.phoneNumber) {

			let regexString = "\\W*([2-9][0-8][0-9])\\W*([2-9][0-9]{2})\\W*([0-9]{4})(\\se?x?t?(\\d*))?"


			self.errorStatesLabelDictionary.removeObjectForKey("phoneNumberTaken")
			if textField.text =~ regexString {
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
		if (textField.secureTextEntry) {
			textField.font = UIFont(name: "Avenir-Book", size: textField.font.pointSize)
		}
		//textField.textColor = UIColor.bl_silverChaliceColor()

		self.updateErrorStateText()
		
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


    func showButton() {
        // If Login button is already showing, animate reshow
        if (self.loginButton.alpha == 1.0) {
            UIView.animateWithDuration(0.15, animations: {
                self.loginButton.alpha = 0.5
            }, completion: {finished in
                UIView.animateWithDuration(0.15, animations: {
                    self.loginButton.alpha = 1.0
                })
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.loginButton.alpha = 1.0
            })
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        // One time storage and setup
        if keyboardHeight == nil {
            keyboardHeight = (sender.userInfo![UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().height
            self.setButtonFrame()
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.loginButton.frame.origin = CGPointMake(0, self.viewSize.height - self.keyboardHeight - UIScreen.mainScreen().bounds.height / 12 - 20)
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
    }
    
    func setButtonFrame() {
        self.loginButton.frame = CGRectMake(0, viewSize.height, viewSize.width, UIScreen.mainScreen().bounds.height / 12)
    }
	func buttonTouchedDown(sender: UIButton) {
		sender.backgroundColor = UIColor.bl_azureNightColor()
	}
    
	@IBAction func didTouchButton(sender: UIButton) {

		sender.backgroundColor = UIColor.bl_azureRadianceColor()
		if errorStatesLabelDictionary.allValues.count == 0 {
		let uc = UserAccountController.sharedInstance
		uc.loginWithInfo(phoneNumber.text, password: password.text)
		uc.newPhoneNumber = phoneNumber.text
		uc.newPassword = password.text
		ViewManager.sharedInstance.ProgressHUD = nil
		ViewManager.sharedInstance.ProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		ViewManager.sharedInstance.ProgressHUD!.mode = MBProgressHUDModeIndeterminate
		ViewManager.sharedInstance.ProgressHUD!.labelText = "Logging Into Bond"

		}
		//uc.newPhoneNumber = phoneNumber.text
		//uc.newPassword = password.text
		//uc.login()
		
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
	
    override func viewWillDisappear(animated: Bool) {
        var count = self.navigationController?.viewControllers.count
        var nextVC:AnyObject? = self.navigationController?.viewControllers[count! - 1]
        if (nextVC is Tour_StartViewController) {
            self.navigationController?.navigationBarHidden = true
        }

		if nextVC?.restorationIdentifier == "tourViewController" {
			 self.navigationController?.navigationBarHidden = true
		}
        super.viewWillDisappear(animated)
    }
}