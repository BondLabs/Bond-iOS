//
//  SetupViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/25/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    // View components
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var activityArray:[ActivityView]?
    var viewBounds:CGSize!
    
    // Initial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* * *
         * * * Do basic setup---------------------------------------------------
         * * */
        
        // Initialize activity views array
        activityArray = Array<ActivityView>()
        for (var i = 0; i < 9; i++) {
            self.activityArray?.append(ActivityView())
        }
        
        // Store view dimensions
        var barHeight = self.navigationController?.navigationBar.bounds.height
        viewBounds = self.view.bounds.size

        // Show navigation bar and set title
        self.view.backgroundColor = self.UIColorFromRGB(0x5A5A5A)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.title = "Profile"
        
        // Set up description label
        self.descLabel.text = "Pick those that best suit you"
        self.descLabel.sizeToFit()
        self.descLabel.textColor = UIColor.whiteColor()
        self.descLabel.center = CGPointMake(viewBounds.width / 2, viewBounds.height / 10)
        
        // Set up nextButton
        self.nextButton.backgroundColor = self.UIColorFromRGB(0x00A4FF)
        self.nextButton.frame = CGRectMake(0, viewBounds.height - UIScreen.mainScreen().bounds.height / 12, viewBounds.width, viewBounds.height / 12)
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.nextButton.setTitle("Next", forState: UIControlState.Normal)
        
        /* * *
         * * * Set up activity views array--------------------------------------
         * * */
        
        // Counter for views
        var count:Int = 0
        
        // Store explicit view bounds
        var width:Int = Int(self.view.bounds.width)
        var height:Int = Int(viewBounds.height)
        
        // Factor to move views over and down by
        var yfactor:CGFloat = 0.25
        
        // Number of views per row and column
        var numXViews:CGFloat = 3.0
        var numYViews:CGFloat = 3.0
        
        // Horizontal edge spacing between views
        // Use this to adjust horizontal spacing of views
        var xedge:CGFloat = 0.25
        
        // Horizontal spacing between views
        var xspace:CGFloat = (1 - 2 * xedge) / (numXViews - 1)
        
        // Vertical spacing between centers of views
        // Use this to adjust vertical spacing of views
        var yspace:CGFloat = 0.225
        
        // Add activity views to main view
        for view in activityArray! {
            self.view.addSubview(view)
            
            // Store row and column of view
            var xindex:CGFloat = CGFloat(count % 3)
            var yindex:CGFloat = CGFloat(Int(count / 3))
            
            // Coordinates of view
            var xtemp = xspace * xindex + xedge
            var ytemp = yspace * yindex + yfactor
            var xcoor = CGFloat(width) * xtemp
            var ycoor = CGFloat(height) * ytemp
            
            // Set up view and add to main view
            view.frame.size = CGSizeMake(50, 80)
            view.center = CGPointMake(xcoor, ycoor)
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.borderWidth = 5.0
            view.backgroundColor = UIColor.whiteColor()
            count++
        }
    }
    
    // RGB to UIColor converter
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}