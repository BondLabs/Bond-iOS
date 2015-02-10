//
//  SignUpViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate {
    
    /* * * 
     * * * View properties------------------------------------------------------
     * * */

    var selectedField:UITextField!
    var keyboardHeight:CGFloat!
	var viewHeight:CGFloat!
    
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
        self.nextButton.setTitle("Next 〉", forState: UIControlState.Normal)
		self.nextButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)
		// self.nextButton.buttonType = UIButtonType.DetailDisclosure
		self.view.bringSubviewToFront(nextButton)
        self.doneButton.alpha = 0.0
        self.doneButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        self.doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.doneButton.setTitle("Done 〉", forState: UIControlState.Normal)
		self.doneButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)
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
		self.lastName.setPlaceholder("Last")
        self.lastName.frame = CGRectMake(self.view.frame.width / 2 + 5, 135, self.view.frame.width / 2 - 15, 40)
		self.lastName.backgroundColor = UIColor.whiteColor()
		self.lastName.textColor = UIColor.bl_silverChaliceColor()
        
        // Set up phoneNumber field
        self.phoneNumber.setPlaceholder("Phone number")
        self.phoneNumber.frame = CGRectMake(10, 185, self.view.frame.width - 20, 40)
		self.phoneNumber.backgroundColor = UIColor.whiteColor()
		self.phoneNumber.textColor = UIColor.bl_silverChaliceColor()
		
		// Set up password field
        self.password.setPlaceholder("Password")
        self.password.frame = CGRectMake(10, 235, self.view.frame.width - 20, 40)
		self.password.backgroundColor = UIColor.whiteColor()
		self.password.textColor = UIColor.bl_silverChaliceColor()
		
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
		UIView.animateWithDuration(0.25, animations: {
			self.view.frame.origin.y = AppData.data.heights.navBarHeight + AppData.data.heights.statusBarHeight - 100
		})
        selectedField = textField
        if (textField != password) {
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
    }

	func textFieldDidEndEditing(textField: UITextField) {
		UIView.animateWithDuration(0.25, animations: {
			self.view.frame.origin.y = AppData.data.heights.navBarHeight + AppData.data.heights.statusBarHeight
		})
		textField.layer.borderWidth = 0
		if (textField.text == "") {
			var placeholder = textField.attributedPlaceholder?.string
			textField.attributedPlaceholder = NSAttributedString(string:placeholder!,
				attributes:[NSForegroundColorAttributeName: AppData.util.UIColorFromRGB(0x6E6E6E)])
		}
		selectedField = nil
		textField.textColor = UIColor.bl_silverChaliceColor()
		if (textField.secureTextEntry) {
			textField.font = UIFont(name: "Avenir-Book", size: textField.font.pointSize)
		}
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		if countElements(string) > 10 {
			return false
		} else {
			return true
		}
	}
    
    // Capture taps on nextButton
    @IBAction func nextButtonTapped(sender: UIButton) {
		if (selectedField == self.firstName) {
            self.showNextButton()
            lastName.becomeFirstResponder()
        } else if (selectedField == self.lastName) {
            self.showNextButton()
            phoneNumber.becomeFirstResponder()
        } else if (selectedField == self.phoneNumber) {
            self.showDoneButton()
            password.becomeFirstResponder()
        }
    }
    
	@IBAction func doneButtonTapped(sender: UIButton) {
		
		let uc = UserAccountController.sharedInstance
		
		uc.newFirstName = firstName.text
		uc.newLastName = lastName.text
		uc.newPhoneNumber = phoneNumber.text
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

	override func viewWillDisappear(animated: Bool) {
		var count = self.navigationController?.viewControllers.count
		var nextVC:AnyObject? = self.navigationController?.viewControllers[count! - 1]
		if (nextVC is TourViewController) {
			self.navigationController?.navigationBarHidden = true
		}
		super.viewWillDisappear(animated)
	}

}