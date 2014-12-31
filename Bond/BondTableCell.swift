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
        // Get profile pic
        self.name = id
        var profPic:UIImage = self.getProfPic()
        
        // Create a circle image view
        var profImageView:CircleImageView = CircleImageView()
        profImageView.setDefaultImage(profPic)
        profImageView.frame.size = CGSizeMake(40, 40)
        profImageView.performSetup(10.0)
        profImageView.center = CGPointMake(30, self.frame.size.height / 2)
        self.addSubview(profImageView)
        
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
