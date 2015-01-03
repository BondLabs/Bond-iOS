//
//  SignUpViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    /* * * 
     * * * View properties------------------------------------------------------
     * * */
    
    var alphabetChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var viewSize:CGSize!
    var selectedField:UITextField!
    var keyboardHeight:CGFloat!
    var barHeight:CGFloat!
    
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
        
        // Store dimensions of bar and screen
        barHeight = self.navigationController?.navigationBar.bounds.height
        viewSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - barHeight!)
        
        // Set delegates
        firstName.delegate = self
        lastName.delegate = self
        phoneNumber.delegate = self
        password.delegate = self
        
        // Set up buttons
        self.nextButton.alpha = 0.0
        self.nextButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.nextButton.setTitle("Next", forState: UIControlState.Normal)
        self.doneButton.alpha = 0.0
        self.doneButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        self.doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.doneButton.setTitle("Done", forState: UIControlState.Normal)
        
        // Add keyboard selectors
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)

        // Set up navigation controller properties
        self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Set up instructions label
        self.descLabel.textColor = UIColor.whiteColor()
        self.descLabel.center = CGPointMake(viewSize.width / 2, viewSize.height / 12)
        
        // Set up firstName and lastName fields
        self.firstName.setPlaceholder("First")
        self.lastName.setPlaceholder("Last")
        self.firstName.frame = CGRectMake(10, viewSize.height * 9/60, viewSize.width / 2 - 15, viewSize.height * 5/60 - 10)
        self.lastName.frame = CGRectMake(viewSize.width / 2 + 5, viewSize.height * 9/60, viewSize.width / 2 - 15, viewSize.height * 5/60 - 10)
        
        // Set up phoneNumber field
        self.phoneNumber.setPlaceholder("Phone number")
        self.phoneNumber.frame = CGRectMake(10, viewSize.height * 14/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        
        // Set up password field
        self.password.setPlaceholder("Password")
        self.password.frame = CGRectMake(10, viewSize.height * 19/60, viewSize.width - 20, viewSize.height * 5/60 - 10)
        
        // Add tap selector to resign keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
    }
    
    /* * *
     * * * Customize keyboard and button animations-----------------------------
     * * */
    
    func hideKeyboard() {
        UIView.animateWithDuration(0.50, animations: {
            self.nextButton.frame.origin = CGPointMake(0, self.viewSize!.height)
            self.nextButton.alpha = 0.0
            self.doneButton.frame.origin = CGPointMake(0, self.viewSize!.height)
            self.doneButton.alpha = 0.0
            self.view.endEditing(true)
        })
        selectedField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedField = textField
        if (textField != password) {
            self.showNextButton()
        } else {
            self.showDoneButton()
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
        if keyboardHeight == nil {
            keyboardHeight = (sender.userInfo![UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().height
            self.setButtonFrames()
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.nextButton.frame.origin = CGPointMake(0, self.viewSize.height - self.keyboardHeight - UIScreen.mainScreen().bounds.height / 12 - 20)
            self.doneButton.frame.origin = CGPointMake(0, self.viewSize.height - self.keyboardHeight - UIScreen.mainScreen().bounds.height / 12 - 20)
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
    }
    
    func setButtonFrames() {
        // Set up next button frame
        self.nextButton.frame = CGRectMake(0, viewSize.height, viewSize.width, UIScreen.mainScreen().bounds.height / 12)
        
        // Set up done button frame
        self.doneButton.frame = CGRectMake(0, viewSize.height, viewSize.width, UIScreen.mainScreen().bounds.height / 12)
    }
    
    override func viewWillDisappear(animated: Bool) {
        var count = self.navigationController?.viewControllers.count
        var nextVC:AnyObject? = self.navigationController?.viewControllers[count! - 1]
        if (nextVC is StartViewController) {
            self.navigationController?.navigationBarHidden = true
        }
        super.viewWillDisappear(true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}