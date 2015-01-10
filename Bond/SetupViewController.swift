//
//  SetupViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/25/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    /* * *
     * * * View properties------------------------------------------------------
     * * */
    
    // View components
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    var activityArray: Array<ActivityView>!
    var activityNames: Array<String>! = ["Adventurer", "Artist", "Athlete", "Culturist", "Gamer", "Hustler", "Musician", "Rebel", "Scholar"]
    var viewBounds:CGSize!
    
    /* * *
     * * * Initial setup of the view--------------------------------------------
     * * */
    
    // Initial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* * *
         * * * Do basic setup---------------------------------------------------
         * * */
        
        // Unhide navigation bar if hidden
        self.navigationController?.navigationBarHidden = false
        
        // Initialize activity views array
        self.activityArray = Array<ActivityView>()
        for possView in self.view.subviews {
            if possView is ActivityView {
                self.activityArray.append(possView as ActivityView)
            }
        }
        
        // Store view dimensions
        var barHeight = self.navigationController?.navigationBar.bounds.height
        viewBounds = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - barHeight!)

        // Show navigation bar and set title
        self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.title = "Profile"
        
        // Set up description label
        self.descLabel.text = "Pick those that best suit you"
        self.descLabel.sizeToFit()
        self.descLabel.textColor = UIColor.whiteColor()
        self.descLabel.center = CGPointMake(viewBounds.width / 2, viewBounds.height / 15)
        
        // Set up nextButton
        self.nextButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        self.nextButton.frame = CGRectMake(0, viewBounds.height - UIScreen.mainScreen().bounds.height / 12 - 20, viewBounds.width, UIScreen.mainScreen().bounds.height / 12)
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
        
        // Factor to move views down by
        var yfactor:CGFloat = 0.25
        
        // Number of views per row and column
        var numXViews:CGFloat = 3.0
        var numYViews:CGFloat = 3.0
        
        // Horizontal edge spacing between views
        // Use this to adjust horizontal spacing of views
        var xedge:CGFloat = 0.20
        
        // Horizontal spacing between views
        var xspace:CGFloat = (1 - 2 * xedge) / (numXViews - 1)
        
        // Vertical spacing between centers of views
        // Use this to adjust vertical spacing of views
        var yspace:CGFloat = 0.225
        
        // Add activity views to main view
        for (index, view) in enumerate(activityArray) {
            // Store row and column of view
            var xindex:CGFloat = CGFloat(count % 3)
            var yindex:CGFloat = CGFloat(Int(count / 3))
            
            // Coordinates of view
            var xtemp = xspace * xindex + xedge
            var ytemp = yspace * yindex + yfactor
            var xcoor = CGFloat(width) * xtemp
            var ycoor = CGFloat(height) * ytemp
            
            // Set up view and add to main view
            view.frame.size = CGSizeMake(70, 110)
            view.center = CGPointMake(xcoor, ycoor)
            count++
            
            // Set up view
            view.setup(self.activityNames[index])
            view.addToggle()
        }
    }

}