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
        self.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)
        
        // Get profile pic
        self.name = id
        var profPic:UIImage = self.getProfPic()
        
        // Create a circle image view
        var profImageView:CircleImageView = CircleImageView()
        profImageView.frame.size = CGSizeMake(45, 45)
        profImageView.center = CGPointMake(30, 30)
        profImageView.setDefaultImage(profPic)
        profImageView.performSetup(15.0)
		profImageView.addBorder(0x00A4FF)
        self.addSubview(profImageView)
        
        // Add a name label
        var nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        nameLabel.sizeToFit()
        nameLabel.frame.origin = CGPointMake(60, 22)
        nameLabel.textColor = UIColor.whiteColor()
        self.addSubview(nameLabel)
        
        // TODO: Get distance
    }
    
    func getProfPic() -> UIImage {
        // Use this to get the profile picture for the bond
        return UIImage(named: "Profile(i).png")!
    }

}
