//
//  BondUser.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/24/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class BondUser: NSObject {

	var name: AnyObject = ""
	var phoneNumber: AnyObject = ""
	var age = 0
	var userID = 0
	var authKey = ""
	
	class func fetchUserWithID(id: Int, authKey: NSString) -> BondUser {
		let user = BondUser()
		user.userID = id
		user.authKey = authKey
		//user.populateUser(id, authKey: authKey)
		UserAccountController.sharedInstance.getAndSaveUserInfo(id, authKey: authKey)
		UserAccountController.sharedInstance.currentUser = user
		return user
		
	}
	
	func populateUser(id: Int, authKey: NSString) {
		
		let dict = UserAccountController.sharedInstance.getUserInfo(id, authKey: authKey)
		if (dict!.objectForKey("error") == nil) {
			NSLog("error getting user info")
		} else {
			
			NSLog("\(dict)")
			//name = dict!.objectForKey("name")!
			//phoneNumber = dict!.objectForKey("phone")!
			//age = (dict!.objectForKey("age") as NSNumber).integerValue
			
		}
}
	
}

