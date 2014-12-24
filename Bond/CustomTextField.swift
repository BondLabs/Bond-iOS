//
//  CustomTextField.swift
//  Bond
//
//  Created by Kevin Zhang on 12/23/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
