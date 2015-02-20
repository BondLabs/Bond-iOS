//
//  ProfileViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 1/1/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Save controller elements
	let YES = true
	let NO = false
	
    var nameLabel: UILabel!
    var distLabel: UILabel!
	var signOutButton: UIBarButtonItem!
    var profImage: CircleImageView!
	var actbuttons: NSMutableArray!

    /* * *
     * * * Do basic setup-------------------------------------------------------
     * * */
    
    override func viewDidLoad() {
        super.viewDidLoad()

		ViewManager.sharedInstance.currentViewController = self
        
        // Set up view properties
		//self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)
		self.view.backgroundColor = UIColor.bl_backgroundColorColor()
        self.navigationItem.title = "You"
		signOutButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedButton:")
		signOutButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir-Light", size: 15)!], forState: UIControlState.Normal)
		

		signOutButton.tintColor = UIColor.whiteColor()
		self.navigationItem.rightBarButtonItem = signOutButton
		//self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
		self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.tabBarItem.selectedImage = UIImage(named: "Profile.png")!
        
        // Darker sub background
        var subBG = UIView()
		//subBG.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
		subBG.backgroundColor = UIColor.whiteColor()
        subBG.layer.borderWidth = 0.5
		//subBG.layer.borderColor = UIColor.blackColor().CGColor
		subBG.layer.borderColor = UIColor.bl_altoColor().CGColor
        subBG.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height / 2)
        subBG.frame.origin = CGPointMake(0, self.view.frame.height / 5)
        self.view.addSubview(subBG)
        
        // Set up profile view for user
        var id = 1 // Get id for the app user
        self.setup(id)
    }
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
    /* * *
     * * * Add all elements to the profile page---------------------------------
     * * */
    
    func setup(id: Int) {
        // Get user details from id
		let user = UserAccountController.sharedInstance.currentUser
		var name: NSString = user.name as NSString
        var dist:Int! = 8
        var profPic:UIImage!
        var activities:[String]! = ["Brainy", "Curious"]

        // Add a name label
        nameLabel = UILabel()
        nameLabel.text = name
		// nameLabel.textColor = UIColor.whiteColor()
		nameLabel.textColor = UIColor.bl_doveGrayColor()
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 24.0)
        nameLabel.sizeToFit()
        nameLabel.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 3 + 40)
        self.view.addSubview(nameLabel)
        
        // Add a distance label if distance is not nil
        distLabel = UILabel()
        distLabel.text = "\(dist) Feet Away"
		distLabel.font = UIFont(name: "Avenir-Medium", size: 18.0)
		distLabel.textColor = UIColor.whiteColor()
        distLabel.sizeToFit()
        distLabel.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 3 + 70)
		//self.view.addSubview(distLabel)
        
        // Add profile picture
        profImage = CircleImageView()
        profImage.frame.size = CGSizeMake(160, 160)
        profImage.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 5)
		//profImage.setDefaultImage(UIImage(named: "Profile(i).png")!)
		//profImage.setDefaultImage(UserAccountController.sharedInstance.currentUser.image)
		profImage.image = UserAccountController.sharedInstance.currentUser.image
        profImage.performSetup(1)
		//profImage.layer.borderColor = UIColor.blackColor().CGColor
		profImage.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
        profImage.layer.borderWidth = 1.0
        self.view.addSubview(profImage)
		
		let chatButton = UIButton()
		chatButton.frame.size = CGSize(width: 160.0, height: 40.0)
		chatButton.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2)
		chatButton.backgroundColor = UIColor.blueColor()
		chatButton.layer.cornerRadius = 20.0
		chatButton.layer.masksToBounds = true
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedButton:")
		chatButton.addGestureRecognizer(tapGestureRecognizer)
		//self.view.addSubview(chatButton)
        
        // Add activity views

		actbuttons = NSMutableArray()
        var activityCount = min(activities.count, 4)
        for var i = 0; i < activityCount; i++ {
            var actView = ActivityView()
            actView.frame.size = CGSizeMake(70, 110)
            actView.setup(activities[i])
            var xfac:Float = (Float(i) + 0.5) / Float(activityCount)
            actView.center = CGPointMake(self.view.frame.width * CGFloat(xfac), self.view.frame.height * 3 / 5)
            self.view.addSubview(actView)
			actbuttons.addObject(actView)
        }
	}
    
	func tappedButton(sender: UITapGestureRecognizer) {
		bondLog("tapped logout button")
		UserAccountController.sharedInstance.logout()
	}

	override func viewWillAppear(animated: Bool) {

		

		let nameAnim = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
		nameAnim.fromValue = NSValue(CGSize: CGSizeMake(0.7, 0.7))
		nameAnim.springBounciness = 15
		nameAnim.toValue = NSValue(CGSize: CGSizeMake(1, 1))
		nameLabel.pop_addAnimation(nameAnim, forKey: "nameLabel")

		let picAnim = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
		picAnim.fromValue = NSValue(CGSize: CGSizeMake(0.7, 0.7))
		picAnim.springBounciness = 15
		picAnim.toValue = NSValue(CGSize: CGSizeMake(1, 1))
		profImage.pop_addAnimation(picAnim, forKey: "nameLabel")

		for view in actbuttons {
			let buttonAnim = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
			buttonAnim.fromValue = NSValue(CGSize: CGSizeMake(0.7, 0.7))
			buttonAnim.springBounciness = 15
			buttonAnim.toValue = NSValue(CGSize: CGSizeMake(1, 1))
			view.pop_addAnimation(picAnim, forKey: "nameLabel")
		}

	}
}
