//
//  UserAccountController.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/21/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class UserAccountController: NSObject {
	
	var newFirstName: NSString = "First"
	var newLastName: NSString = "Last"
	var newPhoneNumber: NSString = "5555555555"
	var newPassword: NSString = "hunter2"
	var newEmail: NSString = "example@example.com"
	var newAge: Int = 1
	var newGender: NSString = "other"
	var newRelationshipStatus = "complicated"
	var id: Int = 1
	var authKey: NSString = "authy"
	
	class var sharedInstance: UserAccountController {
		struct Static {
			static var instance: UserAccountController?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = UserAccountController()
		}
		
		return Static.instance!
	}
	
	
	func register() {
		let name = NSString(format: "%@ %@", newFirstName, newLastName)
		println("registerring for bond")
		registerOrLoginWithURL("http://api.bond.sh/api/users", id: id, name: name, email: newEmail, phone: newPhoneNumber, password: newPassword, age: newAge, gender: newGender, auth_key: nil)
	}
	
	func login() {
		println("loggin into bond")
		let name = NSString(format: "%@ %@", newFirstName, newLastName)
		registerOrLoginWithURL("http://api.bond.sh/api/users", id: id, name: name, email: newEmail, phone: newPhoneNumber, password: newPassword, age: newAge, gender: newGender, auth_key: authKey)
	}
	
	
	func registerOrLoginWithURL(URL: NSString, id: Int, name: NSString, email: NSString, phone: NSString, password: NSString, age: Int, gender: NSString, auth_key: NSString?) {
		
		//Create a string with all the needed data
		
		let post = NSString(format: "id=%d&name=%@&email=%@&phone=%@&password=%@&age=%d&gender=%@", id, name, email, phone, password, age, gender)
		
		//convert the string to an NSData object
		
		let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
		
		//Calculate length for HTTP
		
		let postLength = NSString(format: "%d", postData!.length)
		
		//Create URL Request
		
		let request = NSMutableURLRequest()
		
		//Set the URL
		request.URL = NSURL(string: URL)
		
		//We obviously want to POST
		
		request.HTTPMethod = "POST"
		
		//Put the relevant info into the header (length, auth, format, etc.)
		
		request.setValue(postLength, forHTTPHeaderField: "Content-Length")
		
		if (auth_key != nil) {
			request.setValue(auth_key, forHTTPHeaderField: "auth_key")
		}
		else {
			request.setValue("", forHTTPHeaderField: "auth_key")
		}
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		request.HTTPBody = postData
		
		//Let her rip
		
		let connection = NSURLConnection(request: request, delegate: self)
		
		
	}

}
