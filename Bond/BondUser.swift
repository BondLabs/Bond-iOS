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
	var gender = ""
	var bonds = NSMutableDictionary()
	//key is UID, value is name
	var image = UIImage()
	
	class func fetchUserWithID(id: Int, authKey: NSString) -> BondUser {
		let user = BondUser()
		user.userID = id
		user.authKey = authKey
		//user.populateUser(id, authKey: authKey)
		NSLog("Fetching user with ID: \(id) AuthKey: \(authKey)")
		
		let UAC = UserAccountController.sharedInstance
		let currentUser = UAC.currentUser
		UAC.getAndSaveUserInfo(id, authKey: authKey)
		UAC.currentUser = user
		UAC.isUserLoggedIn = true
		//NSLog("Fetched user with name:\(currentUser.name), phone:\(currentUser.phoneNumber), age:\(currentUser.age), userID:\(currentUser.userID), gender:\(currentUser.gender)")
		return user
		
	}
	
	func setUserPicture(image: UIImage) {
		UserAccountController.sharedInstance.setUserPhoto(userID, authKey: authKey, image: image)
	}
	
	func getUserPicture() {
		
		
		class userPictureReturn: NSObject, NSURLConnectionDataDelegate {
			
			
			class var sharedInstance: userPictureReturn {
				struct Static {
					static var instance: userPictureReturn?
					static var token: dispatch_once_t = 0
				}
				
				dispatch_once(&Static.token) {
					Static.instance = userPictureReturn()
				}
				
				return Static.instance!
			}
			
			let URLResponseData = NSMutableData()
			func connection(connection: NSURLConnection, didFailWithError error: NSError) {
				NSLog("connection %@ failed with error: %@", connection, error.description)
				superclass
			}
			
			func connection(connection: NSURLConnection, didReceiveData data: NSData) {
				URLResponseData.appendData(data)
			}
			
			func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
				URLResponseData.length = 0
			}
			
			func connectionDidFinishLoading(connection: NSURLConnection) {
				let dataString = NSString(data: URLResponseData, encoding: NSUTF8StringEncoding)
				//NSLog("We got a picture response! It's %@", dataString!)
				
				
				var writeError: NSError?
				var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
				
				//NSLog("\(dataDictionary)")
				
				if (dataDictionary?.objectForKey("error") == nil) {
					NSLog("Got Image")
					
					
					
					let imageString: NSString = dataDictionary?.objectForKey("file") as NSString
					let decodedData = NSData(fromBase64String: imageString)
					//let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
					var decodedimage = UIImage(data: decodedData!)
					NSLog("Got an image, it's: \(decodedimage)")
					UserAccountController.sharedInstance.currentUser.image = decodedimage!
					
					//newUser.populateUser(userID.integerValue, authKey: authKey)
					
					
				}
			}
			
			
		}
		
		RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/images/\(self.userID)", api_key: self.authKey, type: requestType.custom, delegate: userPictureReturn.sharedInstance)
		
	}
	
	

	
}

