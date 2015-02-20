//
//  BondsDetailViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit
class BondsDetailViewController: UIViewController {
	
	// Store id of relevant user
	var id:Int!
	var userID:Int!
	var name:String!
	// Store view elements
	var scrollView: UIScrollView!
	var nameLabel: UILabel!
	var distLabel: UILabel!
	var profImage: CircleImageView!
	
	/* * *
	* * * Do basic setup-------------------------------------------------------
	* * */
	
	class var sharedInstance: BondsDetailViewController {
		struct Static {
			static var instance: BondsDetailViewController?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = BondsDetailViewController()
		}
		
		return Static.instance!
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		bondLog("Detail View Did Load")
		ViewManager.sharedInstance.currentViewController = self
		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
		
		// Set up view properties
		self.scrollView = UIScrollView()
		self.scrollView.frame = self.view.bounds
		self.view.addSubview(scrollView)
		self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height * 3)
		//self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
		self.scrollView.backgroundColor = UIColor.bl_backgroundColorColor()
		//self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
		self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.navigationController?.navigationBar.translucent = false
		// var name = "Test" // Get name of user using id
		self.navigationItem.title = self.name
		
		// Darker sub background
		var subBG = UIView()
		//subBG.backgroundColor = AppData.util.UIColorFromRGB(0x535353)
		subBG.backgroundColor = UIColor.whiteColor()
		subBG.layer.borderWidth = 0.5
		//subBG.layer.borderColor = UIColor.blackColor().CGColor
		subBG.layer.borderColor = UIColor.bl_altoColor().CGColor
		subBG.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height / 2)
		subBG.frame.origin = CGPointMake(0, self.view.frame.height / 5)
		self.scrollView.addSubview(subBG)
		
		// Set up profile view for user using id
		bondLog("setting up bonds detailed for user with id \(self.id)")
		if (id != nil) {
		self.setup(id)
		} else {
			let alert = UIAlertView(title: "Opps", message: "An error has occured. If it persists, please report this to bugreport@bond.sh", delegate: nil, cancelButtonTitle: "Okay")
		}
	}
	
	/* * *
	* * * Add all elements to the profile page---------------------------------
	* * */
	
	func setup(id: Int) {
		// Get user details from id
		var name = "Kevin Zhang"
		var dist:Int! = 8
		var profPic:UIImage!
		var activities:[String]! = ["Brainy", "Curious"]
		
		// Add a name label
		nameLabel = UILabel()
		nameLabel.text = name
		nameLabel.textColor = UIColor.bl_doveGrayColor()
		nameLabel.font = UIFont(name: "Helvetica-Bold", size: 24.0)
		nameLabel.frame.size = CGSizeMake(self.view.frame.width, 40)
		nameLabel.textAlignment = NSTextAlignment.Center
		nameLabel.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 3 + 40)
		self.scrollView.addSubview(nameLabel)
		
		// Add profile picture
		profImage = CircleImageView()
		profImage.frame.size = CGSizeMake(160, 160)
		profImage.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 5)
		profImage.setDefaultImage(UIImage(named: "Profile(i).png")!)
		profImage.performSetup(1)
		//profImage.layer.borderColor = UIColor.blackColor().CGColor
		profImage.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
		profImage.layer.borderWidth = 1.0
		self.scrollView.addSubview(profImage)
		
		let chatButton = UIButton()
		chatButton.frame.size = CGSize(width: 160.0, height: 40.0)
		chatButton.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2)
		chatButton.backgroundColor = UIColor.blueColor()
		chatButton.layer.cornerRadius = 20.0
		chatButton.layer.masksToBounds = true
		
		// Add activity views
		var activityCount = min(activities.count, 4)
		for var i = 0; i < activityCount; i++ {
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedButton:")
			var actView = ActivityView()
			actView.frame.size = CGSizeMake(70, 110)
			actView.setup(activities[i])
			var xfac:Float = (Float(i) + 0.5) / Float(activityCount)
			actView.center = CGPointMake(self.view.frame.width * CGFloat(xfac), self.view.frame.height * 3 / 5)
			actView.addGestureRecognizer(tapGestureRecognizer)
			self.scrollView.addSubview(actView)
		}
		
	}
	override func prefersStatusBarHidden() -> Bool {
		return false
	}
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	func tappedButton(sender: UITapGestureRecognizer) {
		
		ViewManager.sharedInstance.ProgressHUD = nil
		
		ViewManager.sharedInstance.ProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		ViewManager.sharedInstance.ProgressHUD!.mode = MBProgressHUDModeCustomView
		let gmailView = GmailLikeLoadingView(frame: CGRectMake(0, 0, 40, 40))
		gmailView.startAnimating()
		ViewManager.sharedInstance.ProgressHUD!.customView = gmailView
		ViewManager.sharedInstance.ProgressHUD!.labelText = "Loading"
		UserAccountController.sharedInstance.getChat(self.id, authKey:UserAccountController.sharedInstance.currentUser.authKey)

		ViewManager.sharedInstance.chatViewController = nil

		let vc = ChatViewController()
		vc.barTitle = self.name
		vc.chatBondID = self.id
		vc.delegate = self
		ViewManager.sharedInstance.chatViewController = vc
		bondLog("tapped Chat Button")
	}
}