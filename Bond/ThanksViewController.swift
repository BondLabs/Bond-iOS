//
//  PushPermissionViewController.swift
//  Bond
//
//  Created by Bond on 2/5/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {
	
	var nameLabel:UILabel!
	var bubble:UIView!
	var bubbleView:UIImageView!
	var promptLabel:UILabel!
	var descLabel:UILabel!
	var subDescLabel:UILabel!
	var noThanksButton:UIButton!
	var nextButton:UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
		ViewManager.sharedInstance.currentViewController = self
		
		ViewManager.sharedInstance.ProgressHUD = nil
		ViewManager.sharedInstance.ProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		ViewManager.sharedInstance.ProgressHUD!.mode = MBProgressHUDModeCustomView
		var gmailFrame = CGRect()
		gmailFrame.size = CGSizeMake(40, 40)
		gmailFrame.origin = CGPointZero
		let gmailView = GmailLikeLoadingView(frame: gmailFrame)
		gmailView.startAnimating()
		self.view.addSubview(gmailView)
		ViewManager.sharedInstance.ProgressHUD!.customView = gmailView
		
		nameLabel = UILabel()
		nameLabel.text = "Hi Daniel"//\(UserAccountController.sharedInstance.currentUser.name as String)"
		nameLabel.font = UIFont(name: "Avenir-Medium", size: 24.0)
		nameLabel.textColor = UIColor.whiteColor()
		nameLabel.sizeToFit()
		nameLabel.center = CGPointMake(self.view.frame.width / 2, 60)
		self.view.addSubview(nameLabel)
		
		bubble = UIView()
		bubble.frame.size = CGSizeMake(self.view.frame.width - 20, self.view.frame.width - 20)
		bubble.frame.origin = CGPointMake(10, 100)
		bubble.layer.cornerRadius = bubble.frame.size.width / 2
		bubble.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(bubble)
		
		promptLabel = UILabel()
		promptLabel.numberOfLines = 0
		promptLabel.text = "Thanks for joining!"
		promptLabel.textColor = AppData.util.UIColorFromRGB(0x00A4FF)
		promptLabel.font = UIFont(name: "Avenir-Medium", size: 21.0)
		promptLabel.sizeToFit()
		promptLabel.center = CGPointMake(self.view.frame.width / 2, 160)
		self.view.addSubview(promptLabel)
		
		subDescLabel = UILabel()
		subDescLabel.numberOfLines = 3
		subDescLabel.text = "Monkeys are adding you\nto the Bond servers!"
		subDescLabel.textColor = AppData.util.UIColorFromRGB(0x00A4FF)
		subDescLabel.textAlignment = NSTextAlignment.Center
		subDescLabel.sizeToFit()
		subDescLabel.font = UIFont(name: "Avenir-Book", size: 14)
		subDescLabel.sizeToFit()
		subDescLabel.center = CGPointMake(self.view.frame.width / 2, 330)
		self.view.addSubview(subDescLabel)
		
		noThanksButton = UIButton()
		noThanksButton.setTitle("No Thanks", forState: UIControlState.Normal)
		noThanksButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 12.0)
		noThanksButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		noThanksButton.sizeToFit()
		noThanksButton.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 70)
		self.view.addSubview(noThanksButton)
		noThanksButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "noThanksTapped"))
		
		nextButton = UIButton()
		nextButton.setTitle("Awesome! 〉", forState: UIControlState.Normal)
		nextButton.backgroundColor = UIColor.whiteColor()
		nextButton.setTitleColor(AppData.util.UIColorFromRGB(0x00A4FF), forState: UIControlState.Normal)
		nextButton.frame.size = CGSizeMake(self.view.frame.width, 50)
		nextButton.frame.origin = CGPointMake(0, self.view.frame.height - 50)
		self.view.addSubview(nextButton)
		nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "nextTapped"))
		
		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillDisappear(animated: Bool) {
		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
		ViewManager.sharedInstance.ProgressHUD?.hide(true)
	}
	
	func nextTapped() {
		self.presentNextController()
	}
	
	func noThanksTapped() {
		self.presentNextController()
	}
	
	func presentNextController() {
		self.performSegueWithIdentifier("segueThanksToPush", sender: self)
	}
	
}