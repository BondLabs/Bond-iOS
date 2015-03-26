//
//  AppDelegate.swift
//  Bond
//
//  Created by Kevin Zhang on 12/22/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var pushNotificationController:PushNotificationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		self.pushNotificationController = PushNotificationController()

		// Set default font for all controls in app
		UILabel.appearance().font = UIFont(name: "Avenir-Book", size: 16.5)
		UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 16.5)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
		UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
		UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16.5)!], forState: UIControlState.Normal)
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		//UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

		//let passwordText = (NSString(data: passwordData as NSData, encoding:NSUTF8StringEncoding))

		bondLog("\(UserAccountController.sharedInstance.userDefaults)")

		let unExists = (UserAccountController.sharedInstance.userDefaults.objectForKey("name") != nil) && !(UserAccountController.sharedInstance.userDefaults.objectForKey("name") as NSString).isEqualToString("")

		bondLog("Username Exists: \(unExists)")





		if unExists {
			//self.performSegueWithIdentifier("goToBondsDirectly", sender: self)
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("AutoLogInViewController") as UIViewController
			let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as UINavigationController
			navigationController.viewControllers = [vc]
			self.window?.rootViewController = navigationController



		}








        return true
    }

	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		println("didRegisterForRemoteNotificationsWithDeviceToken")

		(ViewManager.sharedInstance.currentViewController as PushPermissionViewController).presentNextController()
		
		let currentInstallation = PFInstallation.currentInstallation()

		currentInstallation.setDeviceTokenFromData(deviceToken)
		currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
			// Handle success
		}
	}

	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		bondLog(error)
		
		(ViewManager.sharedInstance.currentViewController as PushPermissionViewController).presentNextController()
	}

	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

		let thing = ((userInfo as NSDictionary).objectForKey("aps") as NSDictionary)
		println("didReceiveRemoteNotification")
		bondLog("userInfo is \(userInfo)")

		let text = thing.objectForKey("alert") as String


		dispatch_async(dispatch_get_main_queue(), {() in

		let view = UIView(frame: CGRectMake(0, 0, 20, 20))
		view.backgroundColor = UIColor.bl_azureRadianceColor()
		ViewManager.sharedInstance.currentViewController?.view.addSubview(view)

			let alert = UIAlertView(title: "Message", message: text, delegate: nil, cancelButtonTitle: "Okay", otherButtonTitles: "Cancel")
			alert.show()

			let notification = JFMinimalNotification(style: JFMinimalNotificationStytle.StyleDefault, title: "Message", subTitle: text, dismissalDelay: 50, touchHandler: {() in
				bondLog("tapped notification")
			})
			//ViewManager.sharedInstance.currentViewController?.view.addSubview(notification)
			self.window!.addSubview(notification)
			if (notification.superview != nil) {
			notification.show()
			}


		})
		//PFPush.handlePush(userInfo)
	}

	func dropdownNotificationBottomButtonTapped() {
		bondLog("bottom button tapped")
	}

	func dropdownNotificationTopButtonTapped() {
		bondLog("top button tapped")
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		if (ViewManager.sharedInstance.currentViewController is SignUpViewController) {
			(ViewManager.sharedInstance.currentViewController as SignUpViewController).hideKeyboard()
		} else if (ViewManager.sharedInstance.currentViewController is LoginViewController) {
			(ViewManager.sharedInstance.currentViewController as LoginViewController).hideKeyboard()
		} else {
			self.window?.endEditing(true)
		}
	}

    // Core Data functions

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "kevinzhang.Bond" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Bond", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Bond.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
}