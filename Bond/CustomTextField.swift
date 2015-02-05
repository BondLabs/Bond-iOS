//
//  CustomTextField.swift
//  Bond
//
//  Created by Kevin Zhang on 12/23/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {

    /* 
     * Use to create a custom text field.
     * Only returns a text field; still needs to be positioned.
     */
    
    /* * *
     * * * Initial setup--------------------------------------------------------
     * * */
    
    required init(coder aDecoder: NSCoder) {
		//NSLog("%@", aDecoder)
        super.init(coder: aDecoder)
        
        self.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
        self.textColor = UIColor.whiteColor()
		self.layer.borderColor = UIColor.whiteColor().CGColor
		self.font = UIFont(name: "Avenir-Book", size: 16.5)
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
			attributes:[NSForegroundColorAttributeName: AppData.util.UIColorFromRGB(0x6E6E6E)])
    }
}