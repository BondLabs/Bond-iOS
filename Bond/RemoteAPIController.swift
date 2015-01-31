//
//  RemoteAPIController.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/24/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit


enum requestType {
	case login
	case register
	case user
	case allbonds
	case bond
	case image
	case custom
}

class RemoteAPIController: NSObject, NSURLConnectionDataDelegate, NSURLConnectionDelegate {

	
	let URLResponseData = NSMutableData()
	var isNetworkBusy = false
	
	
	class var sharedInstance: RemoteAPIController {
		struct Static {
			static var instance: RemoteAPIController?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = RemoteAPIController()
		}
		
		return Static.instance!
	}
	
	//MARK: - POST

	//MARK:Return (not working)
	func returnSendAPIRequestToURL(URL: NSString, data: NSString, api_key: NSString!, type: requestType) -> NSData {
		let post = NSString(format: data)
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
		
		
		//if (api_key != nil) {
		//request.setValue(api_key, forHTTPHeaderField: "x-api-key")
		//}
		//else {
		request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		request.HTTPBody = postData
		
		
		//Let her rip
		isNetworkBusy = true
		
		let urlResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
		let error: NSErrorPointer! = nil;
		
		//let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		return NSURLConnection.sendSyncRequest(request)
		
	}
	//MARK: Regular
	func sendAPIRequestToURL(URL: NSString, data: NSString, api_key: NSString!, type: requestType) {
		let post = NSString(format: data)
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
		
		
		//if (api_key != nil) {
		//request.setValue(api_key, forHTTPHeaderField: "x-api-key")
		//}
		//else {
		if type == requestType.image {
			request.setValue(api_key, forHTTPHeaderField: "x-auth-key")
		}
		
		request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		request.HTTPBody = postData
		
		var connectionDelegate: AnyObject = self
		
		var successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
					}
		
		var failureBlock = {(data: NSData!, error: NSError!) -> Void in
			NSLog("connection %@ failed with error: %@", error.description)
			RemoteAPIController.sharedInstance.isNetworkBusy = false

		}
		
		//Let her rip
		if (type == requestType.login) {
			//connectionDelegate = loginDelegate.sharedInstance
			
			successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
				
				let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
				NSLog("We got a login response! It's %@", dataString!)
				
				
				var writeError: NSError?
				var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
				
				NSLog("\(dataDictionary)")
				//NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
				
				if (dataDictionary?.objectForKey("error") == nil) {
					
					
					
					
					let userID: NSNumber = dataDictionary?.objectForKey("id") as NSNumber
					let authKey: NSString = dataDictionary?.objectForKey("auth_key") as NSString
					
					let newUser = BondUser.fetchUserWithID(userID.integerValue, authKey: authKey)
					UserAccountController.sharedInstance.currentUser.getUserPicture()
					//newUser.populateUser(userID.integerValue, authKey: authKey)
					
					
					if (ViewManager.sharedInstance.currentViewController != nil) {
						
						
						dispatch_async(dispatch_get_main_queue(), {() -> Void in
							let LIVC: UIViewController = ViewManager.sharedInstance.currentViewController!
							LIVC.performSegueWithIdentifier("nextView", sender:LIVC)
							ViewManager.sharedInstance.ProgressHUD?.hide(true)
							NSLog("pushing the view")
							})
					}
					
					NSLog("User created: %@ with ID: %@", newUser.description, userID)
					
					
					
				}

			}
		}
		else if (type == requestType.register) {
			successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
				
				let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
				NSLog("We got a registration response! It's %@", dataString!)
				UserAccountController.sharedInstance.login()
				
				
			}
		
		}
		else if (type == requestType.image) {
			successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
			let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
			NSLog("We got an image response! It's %@", dataString!)
				
				if (ViewManager.sharedInstance.currentViewController != nil) {
					
					
					dispatch_async(dispatch_get_main_queue(), {() -> Void in
						let LIVC: UIViewController = ViewManager.sharedInstance.currentViewController!
						LIVC.performSegueWithIdentifier("nextView", sender:LIVC)
						ViewManager.sharedInstance.ProgressHUD?.hide(true)
						NSLog("pushing the view")
					})
				}
			
			var writeError: NSError?
			var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
			
			NSLog("\(dataDictionary)")
			//NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
			
			if (dataDictionary?.objectForKey("error") == nil) {
				let user = UserAccountController.sharedInstance.currentUser
				
			}
			}
		}

		

		//MARK: Testing shit
		NSURLConnection.asyncRequest(request, success:successBlock ,
			failure:failureBlock)
		//let connection = NSURLConnection(request: request, delegate: connectionDelegate)
	}
	
	//MARK: - GET
	//MARK:Return (not working)
	func returnGetAPIRequestFromURL(URL: NSString, api_key: NSString, type: requestType) -> NSData {
		
		let request = NSMutableURLRequest()
		
		//Set the URL
		request.URL = NSURL(string: URL)
		
		//We obviously want to POST
		
		request.HTTPMethod = "GET"
		
		
		NSLog("Establishing connection to URL \(URL) with protocol \(request.HTTPMethod)")
		//Put the relevant info into the header (length, auth, format, etc.)
		
		
		
		//request.setValue(getLength, forHTTPHeaderField: "Content-Length")
		
		
		//if (api_key != nil) {
		//request.setValue(api_key, forHTTPHeaderField: "x-api-key")
		//}
		//else {
		request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
		request.setValue(api_key, forHTTPHeaderField: "X-AUTH-KEY")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		//request.HTTPBody = getData
		
		var connectionDelegate: AnyObject = self
		
		//Let her rip
		
		
		
		
		let urlResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
		let error: NSErrorPointer! = nil
		//let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		isNetworkBusy = true
		
		return NSURLConnection.sendSyncRequest(request)
		
	}
	//MARK: Regular
	func getAPIRequestFromURL(URL: NSString, api_key: NSString, type: requestType, delegate: NSURLConnectionDataDelegate?) {
		
		//let hasData: Bool = (data == nil)
		//let get = NSString(format: data)
		//convert the string to an NSData object
		
		
		//let getData = get.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
		
		//Calculate length for HTTP
		
		//let getLength = NSString(format: "%d", getData!.length)
		
		//Create URL Request
		
		let request = NSMutableURLRequest()
		
		//Set the URL
		request.URL = NSURL(string: URL)
		
		//We obviously want to POST
		
		request.HTTPMethod = "GET"
		
		NSLog("Establishing connection to URL \(URL) with protocol \(request.HTTPMethod)")
		
		//Put the relevant info into the header (length, auth, format, etc.)
		
		
		
		//request.setValue(getLength, forHTTPHeaderField: "Content-Length")
		
		
		//if (api_key != nil) {
		//request.setValue(api_key, forHTTPHeaderField: "x-api-key")
		//}
		//else {
		request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
		request.setValue(api_key, forHTTPHeaderField: "X-AUTH-KEY")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		//request.HTTPBody = getData
		
		var connectionDelegate: AnyObject = self
		
		var successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
		}
		
		var failureBlock = {(data: NSData!, error: NSError!) -> Void in
			NSLog("connection %@ failed with error: %@", error.description)
			RemoteAPIController.sharedInstance.isNetworkBusy = false
			
		}
		
		//Let her rip
		if (type == requestType.user) {
			var successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
				let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
				NSLog("We got a user response! It's %@", dataString!)
				
				
				var writeError: NSError?
				var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
				
				NSLog("\(dataDictionary)")
				//NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
				
				if (dataDictionary?.objectForKey("error") == nil) {
					
					
					let user = UserAccountController.sharedInstance.currentUser
					
					//let userID: NSNumber = dataDictionary?.objectForKey("id") as NSNumber
					NSLog ("fetched userData!")
					let userName: NSString = dataDictionary?.objectForKey("name") as NSString
					NSLog("name is \(userName)")
					user.name = "\(userName)"
					let userPhone: AnyObject? = dataDictionary?.objectForKey("phone")
					NSLog("phone is \(userPhone)")
					user.phoneNumber = NSString(format:"\(userPhone)")
					let userAge: Int! = dataDictionary?.objectForKey("age") as Int
					NSLog("age is \(userAge)")
					user.age = userAge
					let userGender: AnyObject? = dataDictionary?.objectForKey("gender")
					NSLog("gender is \(userGender)")
					user.gender = NSString(format:"\(userGender)")
					
					NSLog("User is now set! (hopefully) \n Name is \(user.name) \n Phone is \(user.phoneNumber) \n age is \(user.age) \n gender is \(user.gender)")
					
				}
			}

			
		}
		else if (type == requestType.allbonds) {
			connectionDelegate = allBondsDelegate.sharedInstance
		}
			
		else if (type == requestType.custom) {
			connectionDelegate = delegate!
		}
		else {
			connectionDelegate = self
		}
		
		
		//..let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		//let urlResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
		//let error: NSErrorPointer! = nil;
		isNetworkBusy = true
		let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		
		
		
		NSURLConnection.asyncRequest(request, success:successBlock ,
			failure:failureBlock)
		//return NSURLConnection.sendSynchronousRequest(request, returningResponse: urlResponse, error: error)!
	}
	//MARK: - Custom API Request
	func customAPIRequest(URL: NSString, data: NSString, header: (value: NSString, field: NSString)?, HTTPMethod: NSString, delegate: NSURLConnectionDataDelegate) {
		
		let hasData: Bool = !(data.isEqualToString(""))
		
		
		let get = NSString(format: data)
		//convert the string to an NSData object
		
		
		let getData = get.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
		
		//Calculate length for HTTP
		
		let getLength = NSString(format: "%d", getData!.length)
		
		//Create URL Request
		
		let request = NSMutableURLRequest()
		
		//Set the URL
		request.URL = NSURL(string: URL)
		
		//We obviously want to POST
		
		request.HTTPMethod = HTTPMethod
		
		NSLog("Establishing connection to URL \(URL) with protocol \(request.HTTPMethod)")
		
		//Put the relevant info into the header (length, auth, format, etc.)
		
		
		if (hasData)
		{
			request.setValue(getLength, forHTTPHeaderField: "Content-Length")
		}
		//if (api_key != nil) {
		//request.setValue(api_key, forHTTPHeaderField: "x-api-key")
		//}
		//else {
		if header != nil
		{
			request.setValue(header!.value, forHTTPHeaderField: header!.field)
		}
		//request.setValue(api_key, forHTTPHeaderField: "X-AUTH-KEY")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		if (hasData)
		{
			request.HTTPBody = getData
		}
		
		
		//Let her rip
		
		
		
		//..let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		//let urlResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
		//let error: NSErrorPointer! = nil;
		isNetworkBusy = true
		let connection = NSURLConnection(request: request, delegate: delegate)
		//return NSURLConnection.sendSynchronousRequest(request, returningResponse: urlResponse, error: error)!
	}

	
	//MARK: - Default Delegate Stuff
	func connection(connection: NSURLConnection, didFailWithError error: NSError) {
		NSLog("connection %@ failed with error: %@", connection, error.description)
		isNetworkBusy = false
	}
	
	func connection(connection: NSURLConnection, didReceiveData data: NSData) {
		URLResponseData.appendData(data)
	}
	
	func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
		URLResponseData.length = 0
	}
	
	func connectionDidFinishLoading(connection: NSURLConnection) {
		let dataString = NSString(data: URLResponseData, encoding: NSUTF8StringEncoding)
		NSLog("We got a response! It's %@", dataString!)
		isNetworkBusy = false
	}
}

//MARK: - Delegates

//MARK: Bond Fetching
class allBondsDelegate: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
	
	
	let URLResponseData = NSMutableData()
	
	
	class var sharedInstance: allBondsDelegate {
		struct Static {
			static var instance: allBondsDelegate?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = allBondsDelegate()
		}
		
		return Static.instance!
	}
	
	func connection(connection: NSURLConnection, didFailWithError error: NSError) {
		RemoteAPIController.sharedInstance.isNetworkBusy = false
		NSLog("connection %@ failed with error: %@", connection, error.description)
	}
	
	func connection(connection: NSURLConnection, didReceiveData data: NSData) {
		URLResponseData.appendData(data)
	}
	
	func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
		URLResponseData.length = 0
	}
	
	func connectionDidFinishLoading(connection: NSURLConnection) {
		RemoteAPIController.sharedInstance.isNetworkBusy = false
		let dataString = NSString(data: URLResponseData, encoding: NSUTF8StringEncoding)
		NSLog("We got a registration response! It's %@", dataString!)
		
		var writeError: NSError?
		var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
		
		NSLog("\(dataDictionary)")
		//NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
		
		if (dataDictionary?.objectForKey("error") == nil) {
			let user = UserAccountController.sharedInstance.currentUser
			let dict = NSDictionary(dictionary: dataDictionary!)
			user.bonds = dict.allValues
		}
	}
	
}
//MARK: request photo
class requestPhotoDelegate: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
	
	
	let URLResponseData = NSMutableData()
	
	
	class var sharedInstance: requestPhotoDelegate {
		struct Static {
			static var instance: requestPhotoDelegate?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = requestPhotoDelegate()
		}
		
		return Static.instance!
	}
	
	func connection(connection: NSURLConnection, didFailWithError error: NSError) {
		NSLog("connection %@ failed with error: %@", connection, error.description)
	}
	
	func connection(connection: NSURLConnection, didReceiveData data: NSData) {
		URLResponseData.appendData(data)
	}
	
	func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
		URLResponseData.length = 0
	}
	
	func connectionDidFinishLoading(connection: NSURLConnection) {
		let dataString = NSString(data: URLResponseData, encoding: NSUTF8StringEncoding)
		NSLog("We got a registration response! It's %@", dataString!)
		
		var writeError: NSError?
		var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
		
		NSLog("\(dataDictionary)")
		//NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
		
		if (dataDictionary?.objectForKey("error") == nil) {
			let user = UserAccountController.sharedInstance.currentUser
			
		}
	}
	
}

