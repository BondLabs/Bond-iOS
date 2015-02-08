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

/*
		let dataString = NSString(data: password, encoding: NSUTF8StringEncoding)


		UserAccountController.sharedInstance.newPassword = dataString!
		UserAccountController.sharedInstance.newPhoneNumber = phoneNumber

		UserAccountController.sharedInstance.loginWithInfo(phoneNumber, password: dataString!)

		ViewManager.sharedInstance.ProgressHUD = nil
		ViewManager.sharedInstance.ProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		ViewManager.sharedInstance.ProgressHUD!.mode = MBProgressHUDModeIndeterminate
		ViewManager.sharedInstance.ProgressHUD!.labelText = "Logging Into Bond"
*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
