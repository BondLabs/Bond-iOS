//
//  AutoLogInViewController.swift
//  Bond
//
//  Created by Bryce Dougherty on 2/7/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class AutoLogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		let bgImage = UIImageView(image: UIImage(named: "Load Screen i6p"))
		bgImage.frame = self.view.frame
		self.view.addSubview(bgImage)

		self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

		let userDefaults = UserAccountController.sharedInstance.userDefaults

		let userID = userDefaults.objectForKey("userID") as NSNumber
		let authKey = userDefaults.objectForKey("authKey") as String

		let gmailView = GmailLikeLoadingView(frame: CGRectMake(0,0, 40, 40))
		gmailView.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.5)
		self.view.addSubview(gmailView)
		gmailView.startAnimating()

		let label = UILabel()
		label.text = "Logging you into Bond"
		label.font = AppData.data.font
		label.sizeToFit()
		label.center = CGPointMake(screenSize.width * 0.5, (screenSize.height * 0.5) + 50)
		self.view.addSubview(label)




		//let newUser = BondUser.fetchUserWithID(userID.integerValue, authKey: authKey)
		let newUser = BondUser.autoLoginUserWithID(userID.integerValue, authKey: authKey)
		newUser.name = userDefaults.objectForKey("name")! as String
		newUser.phoneNumber = userDefaults.objectForKey("phone")! as String
		newUser.age = userDefaults.objectForKey("age")!.integerValue
		newUser.gender = userDefaults.objectForKey("gender")! as String
		newUser.relationship = userDefaults.objectForKey("relationship")! as String

		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		UserAccountController.sharedInstance.currentUser = newUser

		ViewManager.sharedInstance.currentViewController = self
		
		UserAccountController.sharedInstance.getAndSaveBonds(userID.integerValue, authKey: authKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}
