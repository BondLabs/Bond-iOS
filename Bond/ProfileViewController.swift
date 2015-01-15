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
    var nameLabel: UILabel!
    var distLabel: UILabel!
    var profImage: CircleImageView!

    /* * *
     * * * Do basic setup-------------------------------------------------------
     * * */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up view properties
        self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)
        self.navigationItem.title = "You"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
		self.tabBarItem.selectedImage = UIImage(named: "Profile.png")!
        
        // Darker sub background
        var subBG = UIView()
        subBG.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
        subBG.layer.borderWidth = 0.5
        subBG.layer.borderColor = UIColor.blackColor().CGColor
        subBG.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height / 2)
        subBG.frame.origin = CGPointMake(0, self.view.frame.height / 5)
        self.view.addSubview(subBG)
        
        // Set up profile view for user
        var id = 1 // Get id for the app user
        self.setup(id)
    }
    
    /* * *
     * * * Add all elements to the profile page---------------------------------
     * * */
    
    func setup(id: Int) {
        // Get user details from id
        var name = "Kevin Zhang"
        var dist:Int! = 8
        var profPic:UIImage!
        var activities:[String]! = ["A", "B", "C"]
        
        // Add a name label
        nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textColor = UIColor.whiteColor()
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
        self.view.addSubview(distLabel)
        
        // Add profile picture
        profImage = CircleImageView()
        profImage.frame.size = CGSizeMake(160, 160)
        profImage.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 5)
        profImage.setDefaultImage(UIImage(named: "Profile(i).png")!)
        profImage.performSetup(80)
        profImage.layer.borderColor = UIColor.blackColor().CGColor
        profImage.layer.borderWidth = 1.0
        self.view.addSubview(profImage)
        
        // Add activity views
        var activityCount = min(activities.count, 4)
        for var i = 0; i < activityCount; i++ {
            var actView = ActivityView()
            actView.frame.size = CGSizeMake(70, 110)
            actView.setup(activities[i])
            var xfac:Float = (Float(i) + 0.5) / Float(activityCount)
            actView.center = CGPointMake(self.view.frame.width * CGFloat(xfac), self.view.frame.height * 3 / 5)
            self.view.addSubview(actView)
        }
    }
    
}
