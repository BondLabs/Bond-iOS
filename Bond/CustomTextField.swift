//
//  CustomTextField.swift
//  Bond
//
//  Created by Kevin Zhang on 12/23/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /* 
     * Use to create a custom text field.
     * Only returns a text field; still needs to be positioned.
     */
    
    /* * *
     * * * Initial setup--------------------------------------------------------
     * * */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = self.UIColorFromRGB(0x404040)
        self.textColor = self.UIColorFromRGB(0x6E6E6E)
    }
    
    /* * *
     * * * Use to customize text field------------------------------------------
     * * */
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    func setPlaceholder(placeholderText: String) {
        self.attributedPlaceholder = NSAttributedString(string:placeholderText,
            attributes:[NSForegroundColorAttributeName: self.UIColorFromRGB(0x6E6E6E)])
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
