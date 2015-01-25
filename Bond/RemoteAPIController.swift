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
}

class RemoteAPIController: NSObject, NSURLConnectionDataDelegate, NSURLConnectionDelegate {

	
	let URLResponseData = NSMutableData()
	
	
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
		
		
		let urlResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
		let error: NSErrorPointer! = nil;
		//let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		return NSURLConnection.sendSynchronousRequest(request, returningResponse: urlResponse, error: error)!

	}
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
			request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		request.HTTPBody = postData
		
		var connectionDelegate: AnyObject = self
		
		//Let her rip
		if (type == requestType.login) {
			connectionDelegate = loginDelegate.sharedInstance
			
		}
		else if (type == requestType.register) {
			connectionDelegate = registerDelegate.sharedInstance
		
		}
		else {
			connectionDelegate = self
		}
		
		
		let connection = NSURLConnection(request: request, delegate: connectionDelegate)
	}
	
	func returnGetAPIRequestFromURL(URL: NSString, api_key: NSString, type: requestType) -> NSData {
		
		let request = NSMutableURLRequest()
		
		//Set the URL
		request.URL = NSURL(string: URL)
		
		//We obviously want to POST
		
		request.HTTPMethod = "GET"
		
		//Put the relevant info into the header (length, auth, format, etc.)
		
		
		
		//request.setValue(getLength, forHTTPHeaderField: "Content-Length")
		
		
		//if (api_key != nil) {
		//request.setValue(api_key, forHTTPHeaderField: "x-api-key")
		//}
		//else {
		request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		//request.HTTPBody = getData
		
		var connectionDelegate: AnyObject = self
		
		//Let her rip
		if (type == requestType.user) {
			connectionDelegate = userDelegate.sharedInstance
			
		}
		else {
			connectionDelegate = self
		}
		
		
		
		let urlResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
		let error: NSErrorPointer! = nil
		//let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		return NSURLConnection.sendSynchronousRequest(request, returningResponse: urlResponse, error: nil)!
		
	}
	
	func getAPIRequestFromURL(URL: NSString, api_key: NSString, type: requestType) {
		
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
		
		//Put the relevant info into the header (length, auth, format, etc.)
		
		
		
		//request.setValue(getLength, forHTTPHeaderField: "Content-Length")
		
		
		//if (api_key != nil) {
		//request.setValue(api_key, forHTTPHeaderField: "x-api-key")
		//}
		//else {
		request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
		//}
		
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		//Add the data to the request
		
		//request.HTTPBody = getData
		
		var connectionDelegate: AnyObject = self
		
		//Let her rip
		if (type == requestType.user) {
			connectionDelegate = userDelegate.sharedInstance
			
		}
		else {
			connectionDelegate = self
		}
		
		
		//..let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		//let urlResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
		//let error: NSErrorPointer! = nil;
		let connection = NSURLConnection(request: request, delegate: connectionDelegate)
		//return NSURLConnection.sendSynchronousRequest(request, returningResponse: urlResponse, error: error)!
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
		NSLog("We got a response! It's %@", dataString!)
	}
}

class loginDelegate: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
	
	
	let URLResponseData = NSMutableData()
	
	class var sharedInstance: loginDelegate {
		struct Static {
			static var instance: loginDelegate?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = loginDelegate()
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
		NSLog("We got a login response! It's %@", dataString!)
		
		
		var writeError: NSError?
		var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
		
		NSLog("\(dataDictionary)")
		NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
		
		if (dataDictionary?.objectForKey("error") == nil) {
			
		
		
		
		let userID: NSNumber = dataDictionary?.objectForKey("id") as NSNumber
		let authKey: NSString = dataDictionary?.objectForKey("auth_key") as NSString
			
			let newUser = BondUser.fetchUserWithID(userID.integerValue, authKey: authKey)
			//newUser.populateUser(userID.integerValue, authKey: authKey)
		
		NSLog("User created: %@ with ID: %@", newUser.description, userID)
		}
	}
	
}

class registerDelegate: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
	
	
	let URLResponseData = NSMutableData()
	
	
	class var sharedInstance: registerDelegate {
		struct Static {
			static var instance: registerDelegate?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = registerDelegate()
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
		
		
	}
	
}

class userDelegate: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
	
	
	let URLResponseData = NSMutableData()
	
	
	class var sharedInstance: userDelegate {
		struct Static {
			static var instance: userDelegate?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = userDelegate()
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
		NSLog("We got a user response! It's %@", dataString!)
		
		
		var writeError: NSError?
		var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
		
		NSLog("\(dataDictionary)")
		//NSLog("%@", dataDictionary?.objectForKey("id") as NSNumber)
		
		if (dataDictionary?.objectForKey("error") == nil) {
			
			
			
			
			//let userID: NSNumber = dataDictionary?.objectForKey("id") as NSNumber
		let userName: NSString = dataDictionary?.objectForKey("name") as NSString
		let userPhone: NSString = dataDictionary?.objectForKey("phone") as NSString
		let userAge: Int = dataDictionary?.objectForKey("age") as Int
		let userGender: NSString = dataDictionary?.objectForKey("gender") as NSString
		
			
		

		
	}
	}
	
}


