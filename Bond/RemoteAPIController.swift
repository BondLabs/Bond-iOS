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
    case getChat
    case traits
    case userImage
    case sendMessage
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
    
    //MARK: Return (not working)
    func returnSendAPIRequestToURL(URL: NSString, data: NSString, api_key: NSString, type: requestType) -> NSData {
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
		request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
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
    func sendAPIRequestToURL(URL: NSString, data: NSString, api_key: NSString, type: requestType) {
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
        
        if type == requestType.image || type == requestType.traits || type == requestType.sendMessage {
            request.setValue(api_key, forHTTPHeaderField: "x-auth-key")
        }
        request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //Add the data to the request
        request.HTTPBody = postData
        
		var connectionDelegate: AnyObject = self
        var successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
        }
        
        var failureBlock = {(data: NSData!, error: NSError!) -> Void in
            AppData.bondLog("connection failed with error: \(error.description)")
            RemoteAPIController.sharedInstance.isNetworkBusy = false
        }
        
        //Let her rip
        if (type == requestType.login) {
            //connectionDelegate = loginDelegate.sharedInstance
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got a login response! It's \(dataString!)")
                
                var writeError: NSError?
                var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
                
                AppData.bondLog("\(dataDictionary)")
                
                if (dataDictionary?.objectForKey("error") == nil) {
                    UserAccountController.sharedInstance.keychainItemStore.setObject(UserAccountController.sharedInstance.newPhoneNumber, forKey: kSecAttrAccount)
					UserAccountController.sharedInstance.keychainItemStore.setObject(UserAccountController.sharedInstance.newPassword, forKey: kSecValueData)
                    let userID: NSNumber = dataDictionary?.objectForKey("id") as NSNumber
                    let authKey: NSString = dataDictionary?.objectForKey("auth_key") as NSString

					let currentInstallation = PFInstallation.currentInstallation()
					currentInstallation.addUniqueObject("u\(userID)", forKey: "channels")
					currentInstallation.save()
                    
                    UserAccountController.sharedInstance.getAndSaveBonds(userID.integerValue, authKey: authKey)
                    
                    let newUser = BondUser.fetchUserWithID(userID.integerValue, authKey: authKey)

					UserAccountController.sharedInstance.userDefaults.setObject(userID, forKey: "userID")
					UserAccountController.sharedInstance.userDefaults.setObject(authKey, forKey: "authKey")
					UserAccountController.sharedInstance.userDefaults.synchronize()
                    UserAccountController.sharedInstance.currentUser.getUserPicture()

					bondLog("stuff in keychain: \(UserAccountController.sharedInstance.keychainItemStore.objectForKey(kSecAttrAccount)), and also \(UserAccountController.sharedInstance.keychainItemStore.objectForKey(kSecValueData))")

					AppData.bondLog("User created: \(newUser.description) with ID: \(userID)")
				} else {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        ViewManager.sharedInstance.ProgressHUD?.hide(true)
                        let alert = UIAlertView(title: "Oops", message: dataDictionary?.objectForKey("error") as? String, delegate: nil, cancelButtonTitle: "Okay")
                        
                        alert.show()
                        AppData.bondLog("oops, there was an error")
                    })
                }
            }
        } else if (type == requestType.register) {
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got a registration response! It's \(dataString!)")
                UserAccountController.sharedInstance.login()
            }
        } else if (type == requestType.image) {
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got an image response! It's \(dataString!)")
                
                if (ViewManager.sharedInstance.currentViewController != nil) {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        let LIVC: UIViewController = ViewManager.sharedInstance.currentViewController!
                        LIVC.performSegueWithIdentifier("nextView", sender:LIVC)
                        ViewManager.sharedInstance.ProgressHUD?.hide(true)
                        AppData.bondLog("pushing the view")
                    })
                }
                
                var writeError: NSError?
                var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
                
                AppData.bondLog("\(dataDictionary)")
                
                if (dataDictionary?.objectForKey("error") == nil) {
                    let user = UserAccountController.sharedInstance.currentUser
                } else {
                    let alert = UIAlertView(title: "Oops", message: dataDictionary?.objectForKey("error") as? String, delegate: nil, cancelButtonTitle: "Okay")
                    alert.show()
				}
            }
        }
		
        //MARK: Testing shit
        NSURLConnection.asyncRequest(request, success:successBlock ,
            failure:failureBlock)
    }
    
    //MARK: - GET
    //MARK: Return (not working)
    func returnGetAPIRequestFromURL(URL: NSString, api_key: NSString, type: requestType) -> NSData {
        
        let request = NSMutableURLRequest()
        
        //Set the URL
        request.URL = NSURL(string: URL)
        
        //We obviously want to GET
        request.HTTPMethod = "GET"
        
        AppData.bondLog("Establishing connection to URL \(URL) with protocol \(request.HTTPMethod)")
		
		//Put the relevant info into the header (length, auth, format, etc.)
        request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
        request.setValue(api_key, forHTTPHeaderField: "X-AUTH-KEY")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //Add the data to the request
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
		
		let request = NSMutableURLRequest()
        
        //Set the URL
        request.URL = NSURL(string: URL)
        
        //We obviously want to POST
        request.HTTPMethod = "GET"
        
        AppData.bondLog("Establishing connection to URL \(URL) with protocol \(request.HTTPMethod)")
        
        //Put the relevant info into the header (length, auth, format, etc.)
        request.setValue("37D74DBC-C160-455D-B4AE-A6396FEE7954", forHTTPHeaderField: "x-api-key")
        request.setValue(api_key, forHTTPHeaderField: "X-AUTH-KEY")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var connectionDelegate: AnyObject = self
        var successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
        }
        var failureBlock = {(data: NSData!, error: NSError!) -> Void in
            AppData.bondLog("connection failed with error: \(error.description)")
            RemoteAPIController.sharedInstance.isNetworkBusy = false
        }
        
        //Let her rip
        if (type == requestType.user) {
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got a user response! It's \(dataString!)")
                
                var writeError: NSError?
                var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
                
                AppData.bondLog("\(dataDictionary)")
                
                if (dataDictionary?.objectForKey("error") == nil) {
					let user = UserAccountController.sharedInstance.currentUser
					let userDefaults = UserAccountController.sharedInstance.userDefaults
                    
                    AppData.bondLog ("fetched userData!")
                    let userName: NSString = dataDictionary?.objectForKey("name") as NSString
                    AppData.bondLog("name is \(userName)")
                    user.name = "\(userName)"
					userDefaults.setObject(userName, forKey: "name")

                    let userPhone: AnyObject? = dataDictionary?.objectForKey("phone")
                    AppData.bondLog("phone is \(userPhone)")
                    user.phoneNumber = NSString(format:"\(userPhone)")
					userDefaults.setObject(NSString(format:"\(userPhone)"), forKey: "phone")

                    let userAge: Int! = dataDictionary?.objectForKey("age") as Int
                    AppData.bondLog("age is \(userAge)")
                    user.age = userAge
					userDefaults.setObject(userAge, forKey: "age")

                    let userGender: AnyObject? = dataDictionary?.objectForKey("gender")
                    AppData.bondLog("gender is \(userGender)")
                    user.gender = NSString(format:"\(userGender)")
					userDefaults.setObject(NSString(format:"\(userGender)"), forKey: "gender")

                    let userRelationship: AnyObject? = dataDictionary?.objectForKey("relationship")
                    AppData.bondLog("relationship is \(userRelationship)")
                    user.relationship = NSString(format: "\(userRelationship)")
					userDefaults.setObject(NSString(format: "\(userRelationship)"), forKey: "relationship")

					userDefaults.synchronize()
                    
                    AppData.bondLog("User is now set! (hopefully) \n Name is \(user.name) \n Phone is \(user.phoneNumber) \n age is \(user.age) \n gender is \(user.gender)")
                } else {
                    let alert = UIAlertView(title: "Oops", message: dataDictionary?.objectForKey("error") as? String, delegate: nil, cancelButtonTitle: "Okay")
                    
                    alert.show()
                }
            }
        } else if (type == requestType.allbonds) {
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                RemoteAPIController.sharedInstance.isNetworkBusy = false
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got a registration response! It's \(dataString!)")
                
                var writeError: NSError?
                
				var dataArray: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
				
                AppData.bondLog("Dict is \(dataArray)")
                if dataArray != nil {
                    UserAccountController.sharedInstance.currentUser.bonds = dataArray!
                    AppData.bondLog("bodns are \(UserAccountController.sharedInstance.currentUser.bonds)")
                }
				
				UserAccountController.sharedInstance.getUserPhoto(UserAccountController.sharedInstance.currentUser.userID, authKey: UserAccountController.sharedInstance.currentUser.authKey)
            }
        }
        
        if (type == requestType.traits) {
			println("Requesting traits page")
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got a user response! It's \(dataString!)")
                
                var writeError: NSError?
                var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
                
                AppData.bondLog("\(dataDictionary)")
				
                if (dataDictionary?.objectForKey("error") == nil) {
					// Handle dictionary error
                }
				
                if (ViewManager.sharedInstance.currentViewController != nil) {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        let LIVC: UIViewController = ViewManager.sharedInstance.currentViewController!
                        LIVC.performSegueWithIdentifier("nextView", sender:LIVC)
                        ViewManager.sharedInstance.ProgressHUD?.hide(true)
                        AppData.bondLog("pushing the view")
                    })
                }
            }
		}
        
        if (type == requestType.userImage) {
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got a user response! It's \(dataString!)")
                
                var writeError: NSError?
                var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
                
                AppData.bondLog("\(dataDictionary)")
				
                if (dataDictionary?.objectForKey("error") == nil) {
                    let dataString: String? = dataDictionary?.objectForKey("file") as? String
        			if (dataString != nil){
						bondLog("dataString = \(dataString!)")
						let imageData = NSData(fromBase64String: dataString!)
						var decodedImage = UIImage(data: imageData!)
						if decodedImage != nil {
							UserAccountController.sharedInstance.currentUser.image = decodedImage!
						}
					}
                }
                
				UserAccountController.sharedInstance.getTraits(UserAccountController.sharedInstance.currentUser.userID, authKey: UserAccountController.sharedInstance.currentUser.authKey)
			}
        } else if (type == requestType.custom) {
            connectionDelegate = delegate!
        } else if (type == requestType.getChat) {
            successBlock = {(data: NSData!, response: NSURLResponse!) -> Void in
                RemoteAPIController.sharedInstance.isNetworkBusy = false
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                AppData.bondLog("We got a chat response! It's \(dataString!)")
                
                var writeError: NSError?
                
                var dataArray: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
                
                if (dataArray?.objectForKey("error") == nil) {
                    let id1: Int = dataArray?.objectForKey("id1") as Int
                    bondLog("id 1 = \(id1)")
                    let id2: Int = dataArray?.objectForKey("id2") as Int
                    bondLog("id 2 = \(id2)")
                    let messages: NSArray = dataArray?.objectForKey("messages") as NSArray
                    let messageArray = NSMutableArray()
                    for i in messages {
                        let messageDict = i as NSDictionary
                        let messageID = messageDict.objectForKey("id") as Int
                        let messageContent = messageDict.objectForKey("messages") as String
                        let messageTimestamp = messageDict.objectForKey("time") as String
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.S"
                        let messageTime = dateFormatter.dateFromString(messageTimestamp)
                        
                        let newMessage = Message()
                        
                        newMessage.fromMe = (messageID == UserAccountController.sharedInstance.currentUser.userID)
                        newMessage.text = messageContent
                        newMessage.type = SOMessageTypeText
                        newMessage.date = messageTime
                        messageArray.addObject(newMessage)
                        bondLog("Message is \(newMessage) with ID \(messageID) and Content: \(messageContent) and Timestamp: \(messageTimestamp) and Time: \(messageTime)")
                    }
                    
                    ChatContentManager.sharedManager.currentChat = messageArray
                    bondLog("messages = \(messages)")
                    bondLog(String.fromCString(object_getClassName(messages))!)
                    
                    if (ViewManager.sharedInstance.currentViewController != nil) {
                        ViewManager.sharedInstance.ProgressHUD?.hide(true)
                    }
                } else {
                    ChatContentManager.sharedManager.currentChat = NSMutableArray()
                }
                
                ViewManager.sharedInstance.currentViewController?.navigationController?.presentViewController(ViewManager.sharedInstance.chatViewController!, animated: true, completion: nil)
                ViewManager.sharedInstance.ProgressHUD?.hide(true)
			}
        } else {
            connectionDelegate = self
        }
		
		isNetworkBusy = true
		
        NSURLConnection.asyncRequest(request, success:successBlock ,
            failure:failureBlock)
	}
	
	//MARK: - Custom API Request
    func customAPIRequest(URL: NSString, data: NSString, header: (value: NSString, field: NSString)?, HTTPMethod: NSString, delegate: NSURLConnectionDataDelegate) {
        
        let hasData: Bool = !(data.isEqualToString(""))
		
		//convert the string to an NSData object
		let get = NSString(format: data)
		let getData = get.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        
        //Calculate length for HTTP
        let getLength = NSString(format: "%d", getData!.length)
        
        //Create URL Request
        let request = NSMutableURLRequest()
        
        //Set the URL
        request.URL = NSURL(string: URL)
        
        //Set the method
        request.HTTPMethod = HTTPMethod
		
        AppData.bondLog("Establishing connection to URL \(URL) with protocol \(request.HTTPMethod)")
        
        //Put the relevant info into the header (length, auth, format, etc.)
        if (hasData) {
            request.setValue(getLength, forHTTPHeaderField: "Content-Length")
        }
        if header != nil {
            request.setValue(header!.value, forHTTPHeaderField: header!.field)
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //Add the data to the request
        if (hasData) {
            request.HTTPBody = getData
        }
		
        //Let her rip
        isNetworkBusy = true
        let connection = NSURLConnection(request: request, delegate: delegate)
	}
    
    func customAPIRequestWithBlocks(URL: NSString, data: NSString, header: (value: NSString, field: NSString)?, HTTPMethod: NSString, success:((data: NSData!, response: NSURLResponse!) -> Void), failure:((data: NSData!, response: NSError!) -> Void)) {
        
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
        
        //Set the method
        request.HTTPMethod = HTTPMethod
        
        AppData.bondLog("Establishing connection to URL \(URL) with protocol \(request.HTTPMethod)")
        
        //Put the relevant info into the header (length, auth, format, etc.)
        if (hasData) {
            request.setValue(getLength, forHTTPHeaderField: "Content-Length")
        }
        if header != nil {
            request.setValue(header!.value, forHTTPHeaderField: header!.field)
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //Add the data to the request
        if (hasData) {
            request.HTTPBody = getData
        }
		
        //Let her rip
        isNetworkBusy = true
        NSURLConnection.asyncRequest(request, success:success ,
            failure:failure)
    }
	
    //MARK: - Default Delegate Stuff
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        AppData.bondLog("connection \(connection) failed with error: \(error.description)")
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
        AppData.bondLog("We got a response! It's \(dataString!)")
        isNetworkBusy = false
    }
}

//MARK: - Delegates

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
        AppData.bondLog("connection \(connection) failed with error: \(error.description)")
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        URLResponseData.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        URLResponseData.length = 0
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        let dataString = NSString(data: URLResponseData, encoding: NSUTF8StringEncoding)
        AppData.bondLog("We got a photo response! It's \(dataString!)")
        
        var writeError: NSError?
        var dataDictionary: NSMutableDictionary? = NSJSONSerialization.JSONObjectWithData(URLResponseData, options: NSJSONReadingOptions.AllowFragments, error: &writeError) as? NSMutableDictionary
        
        AppData.bondLog("\(dataDictionary)")
        
        if (dataDictionary?.objectForKey("error") == nil) {
            let user = UserAccountController.sharedInstance.currentUser
        }
    }
}