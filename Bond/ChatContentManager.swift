//
//  ChatContentManager.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/31/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class ChatContentManager: NSObject {
    
    var currentChat:NSMutableArray?
    
    
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
        bondLog("Current chat is \(currentChat)")
        
		return NSArray()
        
        /*if currentChat == nil {
            return NSArray()
        }
        else {
            let message = Message()
            message.fromMe = false
            message.text = "lol you're dumb as hell"
            message.type = SOMessageTypeText
            message.date = NSDate(timeIntervalSinceNow: 50)
            
            currentChat!.addObject(message)
            return currentChat! as NSArray
        }*/
        
        //var result = NSMutableArray()
        
        //return result
        
    }
}
