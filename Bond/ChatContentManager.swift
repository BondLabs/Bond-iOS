//
//  ChatContentManager.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/31/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class ChatContentManager: NSObject {
	class var sharedManager: ChatContentManager {
		struct Static {
			static var instance: ChatContentManager?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = ChatContentManager()
		}
		
		return Static.instance!
	}
	
	func generateConversation() -> NSArray {
		var result = NSMutableArray()
		let message = Message()
		message.fromMe = true
		message.text = "test"
		message.type = SOMessageTypeText
		message.date = NSDate(timeIntervalSinceNow: 50)
		
		result.addObject(message)
		return result
	}
}
