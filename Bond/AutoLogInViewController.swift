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

		let userDefaults = UserAccountController.sharedInstance.userDefaults

		let userID = userDefaults.objectForKey("userID") as NSNumber
		let authKey = userDefaults.objectForKey("authKey") as String

		let newUser = BondUser.fetchUserWithID(userID.integerValue, authKey: authKey)
		newUser.name = userDefaults.objectForKey("name")! as String
		newUser.phoneNumber = userDefaults.objectForKey("phone")! as String
		newUser.age = userDefaults.objectForKey("age")!.integerValue
		newUser.gender = userDefaults.objectForKey("gender")! as String
		newUser.relationship = userDefaults.objectForKey("relationship")! as String

		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		UserAccountController.sharedInstance.currentUser = newUser

		ViewManager.sharedInstance.currentViewController = self
		let phoneNumber: String = UserAccountController.sharedInstance.keychainItemStore.objectForKey(kSecAttrAccount) as String
		let password: NSData = UserAccountController.sharedInstance.keychainItemStore.objectForKey(kSecValueData) as NSData
		UserAccountController.sharedInstance.getAndSaveBonds(userID.integerValue, authKey: authKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
