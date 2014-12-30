//
//  LoginViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var viewSize:CGSize!
    var keyboardHeight:CGFloat!
    var barHeight:CGFloat!
    
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store size of screen
        var barHeight = self.navigationController?.navigationBar.bounds.height
        viewSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - barHeight!)
        
        // Set delegates
        phoneNumber.delegate = self
        password.delegate = self
        
        // Set up login button
        self.loginButton.alpha = 0.0
        self.loginButton.backgroundColor = self.UIColorFromRGB(0x00A4FF)
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.loginButton.setTitle("Log In", forState: UIControlState.Normal)
        
        // Add keyboard selectors
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillShowNotification, object: nil)
        
        // Set up navigation controller properties
        self.view.backgroundColor = self.UIColorFromRGB(0x5A5A5A)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = self.UIColorFromRGB(0x2D2D2D)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Set up instructions label
        self.descLabel.textColor = UIColor.whiteColor()
        self.descLabel.center = CGPointMake(viewSize.width / 2, viewSize.height / 12)
        self.descLabel.text = "Welcome Back!"
        
        // Set up phoneNumber field
        self.phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: self.UIColorFromRGB(0x6E6E6E)])
        self.phoneNumber.frame = CGRectMake(10, viewSize.height * 10/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        self.phoneNumber.backgroundColor = self.UIColorFromRGB(0x404040)
        self.phoneNumber.textColor = self.UIColorFromRGB(0x6E6E6E)
        
        // Set up password field
        self.password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: self.UIColorFromRGB(0x6E6E6E)])
        self.password.frame = CGRectMake(10, viewSize.height * 15/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        self.password.backgroundColor = self.UIColorFromRGB(0x404040)
        self.password.textColor = self.UIColorFromRGB(0x6E6E6E)
        
        // Add tap selector to resign keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
    }
    
    func hideKeyboard() {
        UIView.animateWithDuration(0.5, animations: {
            self.loginButton.frame.origin = CGPointMake(0, self.viewSize!.height)
            self.loginButton.alpha = 0.0
            self.view.endEditing(true)
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.showButton()
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
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        super.viewWillDisappear(animated)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}