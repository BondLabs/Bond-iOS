//
//  UserAccountController.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/21/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit




class UserAccountController: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
	
	
	
	
	
	
	var currentUser: BondUser!
	
	var newFirstName: NSString = "First"
	var newLastName: NSString = "Last"
	var newPhoneNumber: NSString = "5555555555"
	var newPassword: NSString = "hunter2"
	var newEmail: NSString = "example@example.com"
	var newAge: Int = 1
	var newGender: NSString = "other"
	var newRelationshipStatus = "complicated"
	var newProfileImage = UIImage()
	var id: Int = 1
	let authKey = "37D74DBC-C160-455D-B4AE-A6396FEE7954"
	var isUserLoggedIn = false
	
	
	
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
	
	//@availability(deprecated)
	func register() {
		let name = NSString(format: "%@ %@", newFirstName, newLastName)
		println("registerring for bond")
		//registerOrLoginWithURL("http://api.bond.sh/api/users", id: id, name: name, email: newEmail, phone: newPhoneNumber, password: newPassword, age: newAge, gender: newGender, auth_key: nil)
		
		
		
		
		RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/users", data: NSString(format: "name=%@&phone=%@&password=%@&age=%d&gender=%@", name, newPhoneNumber, newPassword, newAge, newGender), api_key: authKey, type: requestType.register)
	}
	
	func registerWithInfo(name: NSString, phone: NSString, password: NSString, age: Int, gender: NSString) {
		RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/users", data: NSString(format: "name=%@&phone=%@&password=%@&age=%d&gender=%@", name, phone, password, age, gender), api_key: authKey, type: requestType.register)
	}
	
	
	@availability(*, deprecated=8.0, message="You relly shouldn't use this, try loginWithInfo() instead")
	func login() {
		
		
		println("loggin into bond out of registration")
		NSLog("Loggin in user with phone number: \(newPhoneNumber), password: \(newPassword)")
		RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/login", data: NSString(format: "phone=%@&password=%@", newPhoneNumber, newPassword), api_key: "", type: requestType.login)
	}
	
	
	func loginWithInfo(phone: NSString, password: NSString)
	{
		println("loggin into bond")
		
		NSLog("value is %@", authKey)
		
		NSLog("Loggin in user with phone number: \(phone), password: \(password)")
		RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/login", data: NSString(format: "phone=%@&password=%@", phone, password), api_key: authKey, type: requestType.login)
	}
	
	func getLoginWithInfo(phone: NSString, password: NSString) -> NSDictionary?
	{
		var writeError: NSError?
		let URLResponseData = RemoteAPIController.sharedInstance.returnSendAPIRequestToURL("http://api.bond.sh/api/login", data: NSString(format: "phone=%@&password=%@", phone, password), api_key: authKey, type: requestType.login)
		var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
		
		
		//NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
		
		if (dataDictionary?.objectForKey("error") != nil)
		{
			
			
			
			
			//let userID: NSNumber = dataDictionary?.objectForKey("id") as NSNumber
			
			
			return NSDictionary(object: "getLoginWithInfo dictionary doesn't exist", forKey: "error")
		}
		else {
			
			return dataDictionary!
		}

		
	}
	
	func getUserInfo(id: Int, authKey: NSString, delegate: NSURLConnectionDataDelegate) -> NSData
	{
		return RemoteAPIController.sharedInstance.returnGetAPIRequestFromURL("http://api.bond.sh/api/users/\(id)", api_key: authKey, type: requestType.custom)
	}
	
	func getAndSaveUserInfo(id: Int, authKey: NSString)
	{
		RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/users/\(id)", api_key: authKey, type: requestType.user, delegate:nil)
	}
	
	func setUserPhoto(id: Int, authKey: NSString, image: UIImage) {
		var imageData = UIImagePNGRepresentation(image)
		let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
		RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/images", data: "id=\(id)&image_data=\(base64String)", api_key: authKey, type: requestType.image)
	}
	
	func getAndSaveBonds(id: Int, authKey: NSString)
	{
		RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/bonds/\(id)", api_key: authKey, type: requestType.allbonds, delegate:nil)
	}
	
	func getBonds(id: Int, authKey: NSString) -> NSDictionary
	{
		
		let dictData = RemoteAPIController.sharedInstance.returnGetAPIRequestFromURL("http://api.bond.sh/api/bonds/\(id)", api_key: authKey, type: requestType.allbonds)
		
		var writeError: NSError?
		let dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(dictData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
		
		var returningDictionary = NSDictionary(object: "empty", forKey: "error")
		if (dataDictionary?.objectForKey("error") == nil) {
			returningDictionary = NSDictionary(dictionary: dataDictionary!)
		}
		return returningDictionary
	}
	
	func sendCustomRequest(data: NSString, header: (value: NSString, field: NSString)?, URL: NSString, HTTProtocol: NSString, delegate: NSURLConnectionDataDelegate)
	{
		RemoteAPIController.sharedInstance.customAPIRequest(URL, data: data, header: header, HTTPMethod: HTTProtocol, delegate: delegate)
	}
	
	func sendCustomRequest(data: NSString, header: (value: NSString, field: NSString)?, URL: NSString, HTTProtocol: NSString, success:((data: NSData!, response: NSURLResponse!) -> Void), failure:((data: NSError, response: NSURLResponse!) -> Void)) {
		
	}
	
	

}
