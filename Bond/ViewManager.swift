//
//  ViewManager.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/31/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit




class ViewManager: NSObject {
	
	class var sharedInstance: ViewManager {
		struct Static {
			static var instance: ViewManager?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = ViewManager()
		}
		
		return Static.instance!
	}

	enum ViewControllerType {
		case current
		case chat
		case first
	}


	var currentViewController: UIViewController?
	var ProgressHUD: MBProgressHUD?
	var chatViewController: UIViewController?
	var firstViewController: UIViewController?

	func setViewController(vc: UIViewController, type: ViewManager.ViewControllerType){
		if type == ViewManager.ViewControllerType.chat {
			self.chatViewController = nil
			self.chatViewController = vc
		}
		else if type == ViewManager.ViewControllerType.chat {
			self.chatViewController = nil
			self.chatViewController = vc
		}
		else if type == ViewManager.ViewControllerType.first {
			self.firstViewController = nil
			self.firstViewController = vc
		}
	}

	
}