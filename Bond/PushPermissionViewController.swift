//
//  PushPermissionViewController.swift
//  Bond
//
//  Created by Bond on 2/5/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class PushPermissionViewController: UIViewController {

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
        
        nameLabel = UILabel()
        nameLabel.text = "Hi \(UserAccountController.sharedInstance.newFirstName as String)"
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
        
        bubbleView = UIImageView()
        var bubbleImage = UIImage(named: "ChatBubble.png")!
        bubbleImage = AppData.util.scaleImage(bubbleImage, size: bubbleImage.size, scale: 0.5)
        bubbleView.image = bubbleImage
        bubbleView.sizeToFit()
        bubbleView.center = CGPointMake(self.view.frame.width / 2, 250)
        self.view.addSubview(bubbleView)
        
        promptLabel = UILabel()
        promptLabel.numberOfLines = 0
        promptLabel.text = "Push Notifications:"
        promptLabel.textColor = AppData.util.UIColorFromRGB(0x00A4FF)
        promptLabel.font = UIFont(name: "Avenir-Medium", size: 21.0)
        promptLabel.sizeToFit()
        promptLabel.center = CGPointMake(self.view.frame.width / 2, 160)
        self.view.addSubview(promptLabel)
        
        descLabel = UILabel()
        descLabel.numberOfLines = 3
        descLabel.text = "Bond needs push notifications \nto function properly. \nWould you like to allow this?"
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.5)
        descLabel.sizeToFit()
        descLabel.center = CGPointMake(self.view.frame.width / 2, 250)
        self.view.addSubview(descLabel)
        
        subDescLabel = UILabel()
        subDescLabel.numberOfLines = 3
        subDescLabel.text = "Bond uses push notifications to tell \n you when someone you should meet \n is near you."
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
    }
    
    func nextTapped() {
		bondLog("Captured tap on next button for push VC")
		// Register for PushNotitications, if running iOS 8
		if (UIApplication.sharedApplication().isRegisteredForRemoteNotifications()) {
			if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings:") {
				
				let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
				let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
				
				UIApplication.sharedApplication().registerUserNotificationSettings(settings)
				UIApplication.sharedApplication().registerForRemoteNotifications()
				
			} else {
				// Register for Push Notifications before iOS 8
				UIApplication.sharedApplication().registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
			}
		} else {
			self.presentNextController()
		}
    }

    func noThanksTapped() {
        self.presentNextController()
    }
    
    func presentNextController() {
        self.performSegueWithIdentifier("seguePushToLocation", sender: self)
    }
    
}
