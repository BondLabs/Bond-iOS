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
		// Borders for activity views
		var xbor:CGFloat = 0.05
		var ytop:CGFloat = 0.07
		var ybot:CGFloat = 0.09
		// Distances between views
		var xdist:CGFloat = width * (1 - 2 * xbor) / CGFloat(numXViews)
		var ydist:CGFloat = height * (1 - ytop - ybot) / CGFloat(numYViews)
		
		// Add activity views to main view
		for (index, view) in enumerate(activities) {
			// Store row and column of view
			var xindex:CGFloat = CGFloat(index % numXViews)
			var yindex:CGFloat = CGFloat(Int(index / numYViews) % numYViews)
			
			// Coordinates of view
			var xcoor = (xindex + 0.5) * xdist + xbor * width
			var ycoor = (yindex + 0.5) * ydist + ytop * height
			
			// Set up view and add to main view
			view.center = CGPointMake(xcoor, ycoor)
			self.view.addSubview(view)
		}
	}
	
}
