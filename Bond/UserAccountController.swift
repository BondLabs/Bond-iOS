//
//  UserAccountController.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/21/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit


class UserAccountController: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    @objc var currentUser: BondUser!
	
    var newFirstName: NSString = "First"
    var newLastName: NSString = "Last"
    var newPhoneNumber: NSString = "5555555555"
    var newPassword: NSString = "hunter2"
    var newEmail: NSString = "example@example.com"
    var newAge: NSString = ""
    var newGender: NSString = "other"
    var newRelationshipStatus = "complicated"
    var newProfileImage = UIImage()
    var id: Int = 1
    let authKey = "37D74DBC-C160-455D-B4AE-A6396FEE7954"
	var newTraits = ""
    var isUserLoggedIn = false
    var otherUserImages = NSMutableDictionary()


	@objc class func objcSharedInstance() -> UserAccountController {
		return UserAccountController.sharedInstance
	}

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
	
	
	var userDefaults = NSUserDefaults.standardUserDefaults()
	
	func logout() {

		CustomBLE.sharedInstance.stopScanning()
		CustomBLE.sharedInstance.timer.invalidate()


		PFInstallation.currentInstallation().removeObjectForKey("channels")
		PFInstallation.currentInstallation().save()
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
		self.newAge = ""
		self.newGender = "other"
		self.newRelationshipStatus = "complicated"
		self.newProfileImage = UIImage()
		self.id = 1

		self.currentUser = nil
		
		//let viewStoryBoard = ViewManager.sharedInstance.currentViewController?.storyboard
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("tourViewController") as UIViewController
		let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as UINavigationController
		navigationController.viewControllers = [vc]

		let viewStoryBoard = UIStoryboard(name: "Main", bundle: nil)
		let startViewController: UIViewController = viewStoryBoard.instantiateInitialViewController() as UIViewController

		bondLog("view controller is \(startViewController)")
		bondLog("vc is \(vc)")

		ViewManager.sharedInstance.currentViewController?.navigationController?.presentViewController(navigationController, animated: true, completion: nil)
		bryceLog("pushing VC \(navigationController) from \(self)")
	}
	
    func register() {
        let name = NSString(format: "%@ %@", newFirstName, newLastName)
        AppData.bondLog(NSString(format: "name=%@&phone=%@&password=%@&age=%d&gender=%@&relationship=%@", name, newPhoneNumber, newPassword, newAge, newGender, newRelationshipStatus))
		
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
    
    func setUserPhoto(id: Int, authKey: NSString, image: UIImage?) {
		if image != nil {

        UserAccountController.sharedInstance.currentUser.image = image!

        var imageData = UIImageJPEGRepresentation(image, 0.5)

			//let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
			//let base64String = imageData.base64EncodedString()
		let base64String = imageData.base64EncodedStringWithOptions(nil)

		let decodedImageData = NSData(base64EncodedString: base64String, options: nil)
		let decodedImage = UIImage(data: decodedImageData!)
			println("image base64 is \(base64String)")

        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/images", data: "id=\(id)&image_data=\(base64String)", api_key: authKey, type: requestType.image)
		}
		else {
			
		}
    }
    
    func getUserPhoto(id: Int, authKey: NSString)
    {
        RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/images/\(id)", api_key: authKey, type: requestType.userImage, delegate:nil)
    }
    
	func getOtherUserPhoto(id: Int, authKey: NSString, passthroughImageView: UIImageView, cell: BondTableCell?)
    {
		cell!.cachedImage = UIImage()
        bondLog("getting other user photo")
		//RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/images/\(id)", api_key: authKey, type: requestType.otherUserImage, delegate:nil)
		RemoteAPIController.sharedInstance.customAPIRequestWithBlocks("http://api.bond.sh/api/images/\(id)", data: "", header: [currentUser.authKey : "x-auth-key"], HTTPMethod: "GET", success: { (data: NSData!, response: NSURLResponse!) -> Void in

			let dict = self.JSONDataToNSDictionary(data)

			if (dict.objectForKey("error") == nil) {
				if let dataString = dict["file"] as? NSString {
					//let dataString = dict["file"] as NSString
					let imageData = NSData(fromBase64String: dataString)
					let decodedImage = UIImage(data: imageData)
					dispatch_async(dispatch_get_main_queue(), {() -> Void in
						if decodedImage == nil && imageData != nil{
							bryceLog("something went wrong decoding the image")
						}
						passthroughImageView.image = decodedImage
						if cell != nil && decodedImage != nil {
							cell!.cachedImage = decodedImage
						}
					})

					//bryceLog("image is \(decodedImage), data \(imageData)")
				}
				else {
					bryceLog("There is no image for this user")
				}


			}

		}) { (data, response) -> Void in
			println()
		}
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
	func getAndReturnTraits(id: Int, authKey: String) -> NSDictionary {


		let dictData = RemoteAPIController.sharedInstance.returnGetAPIRequestFromURL("http://api.bond.sh/api/traits/\(id)", api_key: authKey, type: requestType.traits)

		var writeError: NSError?
		let dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(dictData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary

		var returningDictionary = NSDictionary(object: "empty", forKey: "error")
		if (dataDictionary?.objectForKey("error") == nil) {
			returningDictionary = NSDictionary(dictionary: dataDictionary!)
		}

		return returningDictionary
	}
    func getChat(bondID: Int, authKey: String) {
        RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/chats/\(bondID)", api_key: authKey, type: requestType.getChat, delegate:nil)
    }

	func userIDForBondID(bondID: Int, authKey: String) -> Int {
		//let dictData = RemoteAPIController.sharedInstance.returnSendAPIRequestToURL("http://api.bond.sh/api/bondsusers", api_key: authKey, type: requestType.bond)
		let dictData = RemoteAPIController.sharedInstance.returnSendAPIRequestToURL("http://api.bond.sh/api/bondsusers", data: "bond_id=\(bondID)", api_key: authKey, type: requestType.bondsusers)

		var writeError: NSError?
		let dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(dictData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary

		var returningDictionary = NSDictionary(object: "empty", forKey: "error")
		if (dataDictionary?.objectForKey("error") == nil) {
			returningDictionary = NSDictionary(dictionary: dataDictionary!)
		}

		bondLog("user Id for bond ID \(returningDictionary)")
		let id1 = returningDictionary.objectForKey("id1") as Int
		let id2 = returningDictionary.objectForKey("id2") as Int
		let finalid = (id1 == UserAccountController.sharedInstance.currentUser.userID ? id2 : id1)
		bondLog("the other user in bond \(bondID) is \(finalid)")
		return finalid
		//return 0

	}
    
    func newChat(bondID: Int, userID: Int, message: String, authKey: String) {
        RemoteAPIController.sharedInstance.sendAPIRequestToURL("http://api.bond.sh/api/chats", data: "bond_id=\(bondID)&user_id=\(userID)&message=\(message)", api_key: authKey, type: requestType.sendMessage)
    }
    
    func sendCustomRequest(data: NSString, header: (value: NSString, field: NSString)?, URL: NSString, HTTProtocol: NSString, delegate: NSURLConnectionDataDelegate)
    {
        RemoteAPIController.sharedInstance.customAPIRequest(URL, data: data, header: header, HTTPMethod: HTTProtocol, delegate: delegate)
    }
    
	func sendCustomRequestWithBlocks(data: NSString, header: [NSString : NSString]?, URL: NSString, HTTProtocol: NSString, success:((data: NSData!, response: NSURLResponse!) -> Void), failure:((data: NSData!, response: NSError!) -> Void)) {
        RemoteAPIController.sharedInstance.customAPIRequestWithBlocks(URL, data: data, header: header, HTTPMethod: HTTProtocol, success: success, failure: failure)
    }

	func checkIfPhoneExists(phone: NSString) {
		RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/check/\(phone)", api_key: "", type: requestType.phoneNumberExists, delegate: nil)
	}

	func getOtherUserImageAsync(userID: Int, passthroughImageView: UIImageView) {
		let url = "http://api.bond.sh/api/images/\(userID)"

		self.asyncSetNetImage(url, passthroughImageView: passthroughImageView)
	}

	

	func asyncSetNetImage(url: NSString, passthroughImageView: UIImageView) {

		bryceLog("Other user image URL is \(url)")
		let callback = { (dict: [NSObject : AnyObject]!) -> Void in
			bryceLog("got a response for the image")
			//bryceLog("dict is \(dict)")

			if let dataString = dict["file"] as? NSString {
				//let dataString = dict["file"] as NSString
				let imageData = NSData(fromBase64String: dataString)
				let decodedImage = UIImage(data: imageData)
				dispatch_async(dispatch_get_main_queue(), {() -> Void in
					passthroughImageView.image = decodedImage
				})

				bryceLog("image is \(decodedImage)")
			}
			else {
				bryceLog("There is no image for this user")
			}

		}


		RemoteAPIController.sharedInstance.JSONDownloaderRequest(url, callback: callback)
	}

	func JSONDataToNSDictionary(data: NSData) -> NSDictionary {
		let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
		var writeError: NSError?
		var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
		return dataDictionary!
	}


    
}
