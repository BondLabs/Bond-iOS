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
    var otherUserImages:[String: UIImage]! = []

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
	
	var keychainItemStore = KeychainItemWrapper(identifier: "BondLogin", accessGroup: nil)
	var userDefaults = NSUserDefaults.standardUserDefaults()
	
	func logout() {

		CustomBLE.sharedInstance.stopScanning()
		CustomBLE.sharedInstance.timer.invalidate()

		self.keychainItemStore.resetKeychainItem()
		self.keychainItemStore.setObject("", forKey: kSecAttrAccount)
		self.keychainItemStore.setObject("", forKey: kSecValueData)

		self.userDefaults.setObject("", forKey: "phoneNumber")
		self.userDefaults.setObject("", forKey: "name")
		self.userDefaults.setObject(1, forKey: "age")
		self.userDefaults.setObject("other", forKey: "gender")
		self.userDefaults.setObject("complicated", forKey: "relationship")

		self.userDefaults.synchronize()

		self.newFirstName = ""
		self.newLastName = ""
		self.newPhoneNumber = ""
		self.newEmail = ""
		self.newAge = 1
		self.newGender = "other"
		self.newRelationshipStatus = "complicated"
		self.newProfileImage = UIImage()
		self.id = 1

		self.currentUser = nil
		let viewStoryBoard = UIStoryboard(name: "Main", bundle: nil)
		let startViewController: UIViewController = viewStoryBoard.instantiateInitialViewController() as UIViewController

		bondLog("view controller is \(startViewController)")
		ViewManager.sharedInstance.currentViewController?.presentViewController(startViewController, animated: true, completion: nil)
	}
	
    func register() {
        let name = NSString(format: "%@ %@", newFirstName, newLastName)
        AppData.bondLog(NSString(format: "name=%@&phone=%@&password=%@&age=%d&gender=%@relationship=%@", name, newPhoneNumber, newPassword, newAge, newGender, newRelationshipStatus))
		
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/users", data: NSString(format: "name=%@&phone=%@&password=%@&age=%d&gender=%@&relationship=%@", name, newPhoneNumber, newPassword, newAge, newGender, newRelationshipStatus), api_key: authKey, type: requestType.register)
    }
    
    func registerWithInfo(name: NSString, phone: NSString, password: NSString, age: Int, gender: NSString, relationship: NSString) {
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/users", data: NSString(format: "name=%@&phone=%@&password=%@&age=%d&gender=%@&relationship=%@", name, phone, password, age, gender, relationship), api_key: authKey, type: requestType.register)
    }
    
    
    @availability(*, deprecated=8.0, message="You relly shouldn't use this, try loginWithInfo() instead")
    func login() {
        AppData.bondLog("loggin into bond out of registration")
        AppData.bondLog("Loggin in user with phone number: \(newPhoneNumber), password: \(newPassword)")
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/login", data: NSString(format: "phone=%@&password=%@", newPhoneNumber, newPassword), api_key: "", type: requestType.login)
    }
	
    func loginWithInfo(phone: NSString, password: NSString)
    {
        AppData.bondLog("loggin into bond")
        AppData.bondLog("value is \(authKey)")
        AppData.bondLog("Loggin in user with phone number: \(phone), password: \(password)")
		
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/login", data: NSString(format: "phone=%@&password=%@", phone, password), api_key: authKey, type: requestType.login)
    }
    
    func getLoginWithInfo(phone: NSString, password: NSString) -> NSDictionary?
    {
        var writeError: NSError?
        let URLResponseData = RemoteAPIController.sharedInstance.returnSendAPIRequestToURL("http://api.bond.sh/api/login", data: NSString(format: "phone=%@&password=%@", phone, password), api_key: authKey, type: requestType.login)
        var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
        
        if (dataDictionary?.objectForKey("error") != nil)
        {
            return NSDictionary(object: "getLoginWithInfo dictionary doesn't exist", forKey: "error")
        } else {
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
        UserAccountController.sharedInstance.currentUser.image = image
        var imageData = UIImageJPEGRepresentation(image, 50)
        let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/images", data: "id=\(id)&image_data=\(base64String)", api_key: authKey, type: requestType.image)
    }
    
    func getUserPhoto(id: Int, authKey: NSString)
    {
        RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/images/\(id)", api_key: authKey, type: requestType.userImage, delegate:nil)
    }
    
    func getOtherUserPhoto(id: Int, authKey: NSString)
    {
        RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/images/\(id)", api_key: authKey, type: requestType.otherUserImage, delegate:nil)
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
    
    func sendTraits(bitString: NSString) {
        let authKey = UserAccountController.sharedInstance.currentUser.authKey
        let id = UserAccountController.sharedInstance.currentUser.userID
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/traits", data: "id=\(id)&traits=\(bitString)", api_key: authKey, type: requestType.traits)
    }
    
    func getTraits(id: Int, authKey: String) {
        RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/traits/\(id)", api_key: authKey, type: requestType.traits, delegate: nil)
    }
    
    func getChat(bondID: Int, authKey: String) {
        RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/chats/\(bondID)", api_key: authKey, type: requestType.getChat, delegate:nil)
    }
    
    func newChat(bondID: Int, userID: Int, message: String, authKey: String) {
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/chats", data: "bond_id=\(bondID)&user_id=\(userID)&message=\(message)", api_key: authKey, type: requestType.sendMessage)
    }
    
    func sendCustomRequest(data: NSString, header: (value: NSString, field: NSString)?, URL: NSString, HTTProtocol: NSString, delegate: NSURLConnectionDataDelegate)
    {
        RemoteAPIController.sharedInstance.customAPIRequest(URL, data: data, header: header, HTTPMethod: HTTProtocol, delegate: delegate)
    }
    
    func sendCustomRequestWithBlocks(data: NSString, header: (value: NSString, field: NSString)?, URL: NSString, HTTProtocol: NSString, success:((data: NSData!, response: NSURLResponse!) -> Void), failure:((data: NSData!, response: NSError!) -> Void)) {
        RemoteAPIController.sharedInstance.customAPIRequestWithBlocks(URL, data: data, header: header, HTTPMethod: HTTProtocol, success: success, failure: failure)
    }
    
}
