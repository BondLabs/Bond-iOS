//
//  BondTableCell.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondTableCell: UITableViewCell {
    
    var name:String!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(id: String) {
        // Set up basic properties
        self.backgroundColor = self.UIColorFromRGB(0x5A5A5A)
        
        // Get profile pic
        self.name = id
        var profPic:UIImage = self.getProfPic()
        
        // Create a circle image view
        var profImageView:CircleImageView = CircleImageView()
        profImageView.frame.size = CGSizeMake(45, 45)
        profImageView.center = CGPointMake(30, 30)
        profImageView.setDefaultImage(profPic)
        profImageView.performSetup(15.0)
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
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
