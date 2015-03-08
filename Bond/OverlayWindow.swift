//
//  OverlayWindow.swift
//  Bond
//
//  Created by Bryce Dougherty on 3/7/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

import UIKit

class OverlayWindow: UIWindow {


	override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
		var pointInside = false

		for view in self.subviews {
			if (CGRectContainsPoint(view.frame, point)) {
				pointInside = true;
			}

		}
		return pointInside
	}
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/

}
