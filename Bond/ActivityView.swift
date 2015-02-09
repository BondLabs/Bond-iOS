//
//  ActivityView.swift
//  Bond
//
//  Created by Kevin Zhang on 12/25/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class ActivityView: UIView {
    
    var iconView:UIImageView!
    var nameLabel:UILabel!
    
    func setName(name: String) {
        nameLabel.text! = name
        nameLabel.frame = CGRectMake(0, self.bounds.width, self.bounds.width, self.bounds.height - self.bounds.width)
        self.addSubview(nameLabel)
    }
    
    func setImage(icon: UIImage) {
        iconView.image = icon
        iconView.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.width)
    }
    
}