//
//  LoginViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    /* * *
     * * * View properties------------------------------------------------------
     * * */
    
    var viewSize:CGSize!
    var keyboardHeight:CGFloat!
    var barHeight:CGFloat!
    
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
        
        // Add keyboard selectors
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillShowNotification, object: nil)
        
        // Set up navigation controller properties
        self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
        
        // Set up instructions label
        self.descLabel.textColor = UIColor.whiteColor()
        self.descLabel.center = CGPointMake(viewSize.width / 2, viewSize.height / 12)
        self.descLabel.text = "Welcome Back!"
        
        // Set up phoneNumber field
        self.phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: AppData.util.UIColorFromRGB(0x6E6E6E)])
        self.phoneNumber.frame = CGRectMake(10, viewSize.height * 10/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        self.phoneNumber.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
        self.phoneNumber.textColor = AppData.util.UIColorFromRGB(0x6E6E6E)
        
        // Set up password field
        self.password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: AppData.util.UIColorFromRGB(0x6E6E6E)])
        self.password.frame = CGRectMake(10, viewSize.height * 15/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        self.password.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
        self.password.textColor = AppData.util.UIColorFromRGB(0x6E6E6E)
        
        // Add tap selector to resign keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.showButton()
		if (textField.text == "") {
			var placeholder = textField.attributedPlaceholder?.string
			textField.attributedPlaceholder = NSAttributedString(string:placeholder!,
				attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
		}
		textField.layer.borderWidth = 1.5
    }

	func textFieldDidEndEditing(textField: UITextField) {
		textField.layer.borderWidth = 0
		if (textField.text == "") {
			var placeholder = textField.attributedPlaceholder?.string
			textField.attributedPlaceholder = NSAttributedString(string:placeholder!,
				attributes:[NSForegroundColorAttributeName: AppData.util.UIColorFromRGB(0x6E6E6E)])
		}
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
    
	@IBAction func didTouchButton(sender: UIButton) {
		let uc = UserAccountController.sharedInstance


		uc.loginWithInfo(phoneNumber.text, password: password.text)
		uc.newPhoneNumber = phoneNumber.text
		uc.newPassword = password.text
		ViewManager.sharedInstance.ProgressHUD = nil
		ViewManager.sharedInstance.ProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		ViewManager.sharedInstance.ProgressHUD!.mode = MBProgressHUDModeIndeterminate
		ViewManager.sharedInstance.ProgressHUD!.labelText = "Logging Into Bond"

		
		//uc.newPhoneNumber = phoneNumber.text
		//uc.newPassword = password.text
		//uc.login()
		
	}
    /* * *
     * * * Capture segue events
     * * */
    
    override func viewWillDisappear(animated: Bool) {
        var count = self.navigationController?.viewControllers.count
        var nextVC:AnyObject? = self.navigationController?.viewControllers[count! - 1]
        if (nextVC is Tour_StartViewController) {
            self.navigationController?.navigationBarHidden = true
        }
        super.viewWillDisappear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoginSegue" || segue.identifier == "nextView") {
            // Use to authenticate login and cancel segue if illegal login credentials
            AppData.data.userID = 1 // Store user id if successful authentication
        } else if segue.destinationViewController is Tour_StartViewController {
            self.navigationController?.navigationBarHidden = true
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}