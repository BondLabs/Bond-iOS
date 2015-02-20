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
	var relationship = ""
	var bonds = NSMutableDictionary()
	var traitsString: String?

	//key is UID, value is name
	var image = UIImage()

	class func fetchUserWithID(id: Int, authKey: NSString) -> BondUser {
		let user = BondUser()
		user.userID = id
		user.authKey = authKey

		AppData.bondLog("Fetching user with ID: \(id) AuthKey: \(authKey)")

		let UAC = UserAccountController.sharedInstance
		let currentUser = UAC.currentUser
		UAC.getAndSaveUserInfo(id, authKey: authKey)
		UAC.currentUser = user
		UAC.isUserLoggedIn = true
		return user
	}

	class func autoLoginUserWithID(id: Int, authKey: NSString) -> BondUser {
		let user = BondUser()
		user.userID = id
		user.authKey = authKey

		AppData.bondLog("Fetching user with ID: \(id) AuthKey: \(authKey)")

		let UAC = UserAccountController.sharedInstance
		let currentUser = UAC.currentUser
		UAC.currentUser = user
		UAC.isUserLoggedIn = true
		return user
	}

	func setUserPicture(image: UIImage) {
		UserAccountController.sharedInstance.setUserPhoto(userID, authKey: authKey, image: image)
	}

	func getTraits() -> NSArray {
		let Array = NSMutableArray()
		if (UserAccountController.sharedInstance.currentUser.traitsString != nil) {
			for i in AppData.data.activityNames {

				let stringIndex = (AppData.data.activityNames as NSArray).indexOfObject(i)

				let range = NSRange(location: stringIndex, length: 1)

				let singleString = "\(UserAccountController.sharedInstance.currentUser.traitsString?[stringIndex])"
				Array.addObject(singleString)
			}
		}
		return Array as NSArray
	}

	func getActiveTraits() -> NSArray {
		let traitsArray = NSMutableArray()

		if self.traitsString != nil {

			for i in 0...countElements(self.traitsString!) {
				if self.traitsString![i] == "1" {
					traitsArray.addObject(AppData.data.activityNames[i])
				}
			}


		}

		return traitsArray
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
				AppData.bondLog("connection \(connection) failed with error: \(error.description)")
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

				var writeError: NSError?
				var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary

				if (dataDictionary?.objectForKey("error") == nil) {
					AppData.bondLog("Got Image")

					let imageString: NSString = dataDictionary?.objectForKey("file") as NSString
					let decodedData = NSData(fromBase64String: imageString)
					var decodedimage = UIImage(data: decodedData!)
					AppData.bondLog("Got an image, it's: \(decodedimage)")
					UserAccountController.sharedInstance.currentUser.image = decodedimage!
				}
			}
		}

		RemoteAPIController.sharedInstance.getAPIRequestFromURL("http://api.bond.sh/api/images/\(self.userID)", api_key: self.authKey, type: requestType.custom, delegate: userPictureReturn.sharedInstance)
	}

}

