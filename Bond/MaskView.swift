//
//  MaskView.swift
//  Bond
//
//  Created by Kevin Zhang on 1/11/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class MaskView: UIView {

	var circleBounds:CGRect!

	func setCircleBounds(circleBounds:CGRect) {
		self.circleBounds = circleBounds
	}

	func crop(color:CGColor) {
		// Create a rectangle of appropriate size and fill with correct color
		var viewRect = CGRect(origin: CGPointZero, size: self.frame.size)
		UIGraphicsBeginImageContext(self.frame.size)
		var context = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, color)
		CGContextFillRect(context, viewRect)

		// Get intersecting region
		var intersect = CGRectIntersection(self.frame, self.circleBounds)
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