//
//  MaskView.swift
//  Bond
//
//  Created by Kevin Zhang on 1/11/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class MaskView: UIView {

	func cropCircle(circleBounds:CGRect) {
		// Create a rectangle of appropriate size and fill with correct color
		var viewRect = CGRect(origin: CGPointZero, size: self.frame.size)
		UIGraphicsBeginImageContext(self.frame.size)
		var context:CGContextRef = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, UIColor(red: 0/255.0, green: 164/255.0, blue: 255/255.0, alpha: 0.5).CGColor)
		CGContextFillRect(context, viewRect)

		// Get intersecting region
		var intersect = CGRectIntersection(self.frame, circleBounds)
		// Add a circle in the intersection
		CGContextAddEllipseInRect(context, intersect)
		CGContextClip(context)
		CGContextClearRect(context, intersect)
		// Clear the circle
		CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
		CGContextFillRect(context, intersect)

		// Create a new image and add it to the view
		var image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		var imageView = UIImageView(image: image)
		self.addSubview(imageView)
	}

}