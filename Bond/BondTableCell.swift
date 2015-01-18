//
//  BondTableCell.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondTableCell: UITableViewCell {
    
    // Store name of the user
    var name:String!
    
    /* * *
     * * * Do setup
     * * */
    
    func setup(id: String) {
        // Set up basic properties
        self.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
        
        // Get profile pic
        self.name = id
        var profPic:UIImage = self.getProfPic()
        
        // Create a circle image view
        var profImageView:CircleImageView = CircleImageView()
        profImageView.frame.size = CGSizeMake(45, 45)
        profImageView.center = CGPointMake(30, 30)
        profImageView.setDefaultImage(profPic)
        profImageView.performSetup(0.67)
		profImageView.addBorder(0x00A4FF)
        self.addSubview(profImageView)
        
        // Add a name label
        var nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 18.0)
        nameLabel.sizeToFit()
        nameLabel.frame.origin = CGPointMake(60, 8)
        nameLabel.textColor = UIColor.whiteColor()
        self.addSubview(nameLabel)
        
        // TODO: Get distance
		var dist:Int! = nil // Get distance here somehow
		var distLabel = UILabel()
		if var check = dist {
			distLabel.text = "\(dist) Feet Away"
		} else {
			distLabel.text = "Not Here"
		}
		distLabel.sizeToFit()
		distLabel.textColor = UIColor.whiteColor()
		distLabel.font = UIFont(name: "Avenir-Medium", size: 13.0)
		distLabel.frame.origin = CGPointMake(60, 32)
		self.addSubview(distLabel)

		// TODO: Get time
		srand48(0)
		var time:Int! = Int(drand48() * 100000)
		var tdenom:String!
		if (time > 365 * 24) {
			tdenom = "y"
			time = Int(time / 365 / 24)
		} else if (time > 30 * 24) {
			tdenom = "m"
			time = Int(time / 30 / 24)
		} else if (time > 7 * 24) {
			tdenom = "d"
			time = Int(time / 7 / 24)
		} else {
			tdenom = "h"
		}
		var timeLabel = UILabel()
		timeLabel.text = "\(time)\(tdenom)"
		timeLabel.font = UIFont(name: "Avenir-Book", size: 9.0)
		timeLabel.textColor = UIColor.whiteColor()
		timeLabel.sizeToFit()
		timeLabel.center = CGPointMake(self.frame.width - 15, 30)
		self.addSubview(timeLabel)
    }
    
    func getProfPic() -> UIImage {
        // Use this to get the profile picture for the bond
        return UIImage(named: "Profile(i).png")!
    }

}
