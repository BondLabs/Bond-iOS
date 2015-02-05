//
//  TraitArrayViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 1/17/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class TraitArrayViewController: UIViewController {
	
	func setup(frame: CGRect, activities: [ActivityView]) {
		self.view.frame = CGRect(origin: CGPointZero, size: frame.size)
		
		// Store explicit view bounds for ONE view controller
		var width = self.view.frame.width
		var height = self.view.frame.height
		// Number of views per row and column
		var numXViews:Int = 3
		var numYViews:Int = 3
		// Distances between views
		var xdist:CGFloat = width / CGFloat(numXViews)
		var ydist:CGFloat = height / CGFloat(numYViews)
		
		// Add activity views to main view
		for (index, view) in enumerate(activities) {
			// Store row and column of view
			var xindex:CGFloat = CGFloat(index % numXViews)
			var yindex:CGFloat = CGFloat(Int(index / numYViews) % numYViews)
			
			// Coordinates of view
			var xcoor = (xindex + 0.5) * xdist
			var ycoor = (yindex + 0.5) * ydist
			
			// Set up view and add to main view
			view.center = CGPointMake(xcoor, ycoor)
			self.view.addSubview(view)
		}
	}
	
}
