//
//  SignUpViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var alphabetChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var viewSize:CGSize!
    var selectedField:UITextField!
    
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store size of screen
        var barHeight = self.navigationController?.navigationBar.bounds.height
        viewSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - barHeight!)
        
        // Set delegates
        firstName.delegate = self
        lastName.delegate = self
        phoneNumber.delegate = self
        password.delegate = self
        
        // Hide nextButton
        self.nextButton.hidden = true
        
        // Add keyboard selectors
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)

        // Set up colors
        self.view.backgroundColor = self.UIColorFromRGB(0x5A5A5A)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = self.UIColorFromRGB(0x2D2D2D)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Set up instructions label
        self.descLabel.textColor = UIColor.whiteColor()
        self.descLabel.center = CGPointMake(viewSize.width / 2, viewSize.height / 12)
        
        // Set up firstName and lastName fields
        self.firstName.attributedPlaceholder = NSAttributedString(string:"First",
            attributes:[NSForegroundColorAttributeName: self.UIColorFromRGB(0x6E6E6E)])
        self.lastName.attributedPlaceholder = NSAttributedString(string:"Last",
            attributes:[NSForegroundColorAttributeName: self.UIColorFromRGB(0x6E6E6E)])
        self.firstName.frame = CGRectMake(10, viewSize.height * 9/60, viewSize.width / 2 - 15, viewSize.height * 5/60 - 10)
        self.lastName.frame = CGRectMake(viewSize.width / 2 + 5, viewSize.height * 9/60, viewSize.width / 2 - 15, viewSize.height * 5/60 - 10)
        self.firstName.backgroundColor = self.UIColorFromRGB(0x404040)
        self.firstName.textColor = self.UIColorFromRGB(0x6E6E6E)
        self.lastName.backgroundColor = self.UIColorFromRGB(0x404040)
        self.lastName.textColor = self.UIColorFromRGB(0x6E6E6E)
        
        // Set up phoneNumber field
        self.phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: self.UIColorFromRGB(0x6E6E6E)])
        self.phoneNumber.frame = CGRectMake(10, viewSize.height * 14/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        self.phoneNumber.backgroundColor = self.UIColorFromRGB(0x404040)
        self.phoneNumber.textColor = self.UIColorFromRGB(0x6E6E6E)
        
        // Set up password field
        self.password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: self.UIColorFromRGB(0x6E6E6E)])
        self.password.frame = CGRectMake(10, viewSize.height * 19/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        self.password.backgroundColor = self.UIColorFromRGB(0x404040)
        self.password.textColor = self.UIColorFromRGB(0x6E6E6E)
        
        // Add tap selector to resign keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignKeyboard"))
    }
    
    func resignKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.nextButton.setTitle("", forState: UIControlState.Normal)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedField = textField
        if (textField == firstName) {
            nextButton.setTitle("Next", forState: UIControlState.Normal)
        } else if (textField == lastName) {
            nextButton.setTitle(" Next ", forState: UIControlState.Normal)
        } else if (textField == phoneNumber) {
            nextButton.setTitle("  Next  ", forState: UIControlState.Normal)
        } else {
            nextButton.setTitle("Done!", forState: UIControlState.Normal)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.resignKeyboard()
        selectedField = nil
        return true
    }
    
    // Use to ensure only certain characters are typeable in text fields
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    // Capture taps on nextButton
    @IBAction func nextButtonTapped(sender: UIButton) {
        if (selectedField == self.firstName) {
            lastName.becomeFirstResponder()
            nextButton.setTitle(" Next ", forState: UIControlState.Normal)
        } else if (selectedField == self.lastName) {
            phoneNumber.becomeFirstResponder()
            nextButton.setTitle("  Next  ", forState: UIControlState.Normal)
        } else if (selectedField == self.phoneNumber) {
            password.becomeFirstResponder()
            nextButton.setTitle("Done!", forState: UIControlState.Normal)
        } else if (selectedField == self.password) {
            self.resignKeyboard()
            self.resignFirstResponder()
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if (self.nextButton.hidden) {
            var keyboardSize:CGRect
            keyboardSize = (sender.userInfo![UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
            self.nextButton.frame = CGRectMake(0, viewSize.height - keyboardSize.height - UIScreen.mainScreen().bounds.height / 12 - 20, viewSize.width, UIScreen.mainScreen().bounds.height / 12)
            self.nextButton.backgroundColor = self.UIColorFromRGB(0x00A4FF)
            self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        self.nextButton.hidden = false
    }
    
    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(0.2, animations: {
            self.nextButton.alpha = 0.0
        }, completion: { finished in
            self.nextButton.hidden = true
            self.nextButton.alpha = 1.0
        })
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