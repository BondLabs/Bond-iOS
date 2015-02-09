//
//  SetupViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/25/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class TraitsViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    /* * *
     * * * View properties------------------------------------------------------
     * * */
    
    // View components
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
	var traitsPageVC:UIPageViewController!
	var pageVCFrame:CGRect!
	var traitViewFrame:CGRect!
	var traitsVCs:[TraitArrayViewController]!
	var currentIndex:Int! = 0
	var nextIndex:Int!
    var activityArray: [ActivityView]!
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

		self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        // Store view dimensions
        var barHeight = self.navigationController?.navigationBar.bounds.height
        viewBounds = CGSizeMake(AppData.data.viewWidth, AppData.data.heights.navViewHeight)

        // Show navigation bar and set title
		//self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
		self.view.backgroundColor = UIColor.bl_backgroundColorColor()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.title = "Profile"
        
        // Set up description label
        self.descLabel.text = "Pick those that best suit you"
        self.descLabel.sizeToFit()
        self.descLabel.textColor = UIColor.bl_doveGrayColor()
        self.descLabel.center = CGPointMake(viewBounds.width / 2, viewBounds.height / 15)
        
        // Set up nextButton
        self.nextButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        self.nextButton.frame = CGRectMake(0, viewBounds.height - 50, viewBounds.width, 50)
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.nextButton.setTitle("Next 〉", forState: UIControlState.Normal)
		self.nextButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedNext:")
		self.nextButton.addGestureRecognizer(gestureRecognizer)
        
        /* * *
         * * * Set up activity views and page controller -----------------------
         * * */

		// Initialize page view controller
		traitsPageVC = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
		traitsPageVC.delegate = self
		traitsPageVC.dataSource = self
		traitsPageVC.view.frame = CGRectMake(0, 50, self.view.frame.width, self.view.frame.height - 100)
		traitViewFrame = CGRect(origin: CGPointZero, size: CGSizeMake(traitsPageVC.view.frame.width, traitsPageVC.view.frame.height - AppData.data.heights.navBarHeight - AppData.data.heights.pageControlHeight))
		activityArray = [ActivityView]()

		// Store all activity views
		for activity in AppData.data.activityNames {
			var newActivity = ActivityView()
			newActivity.frame.size = CGSizeMake(70, 110)
			newActivity.setup(activity)
			newActivity.addToggle()
			activityArray.append(newActivity)
		}
		
		// Create and store all view controllers to be shown
		var viewCount = Int(ceil(Double(activityArray.count / 9)))
		for var i = 0; i < viewCount; i++ {
			var currActivities = [ActivityView]()
			for var j = 9 * i; j < min(9 * (i + 1), activityArray.count); j++ {
				currActivities.append(activityArray[j])
			}
			var newTraitView = TraitArrayViewController()
			newTraitView.setup(traitViewFrame, activities: currActivities)
			if (traitsVCs == nil) {
				traitsVCs = [newTraitView]
			} else {
				traitsVCs.append(newTraitView)
			}
		}

		// Set up and add page view controller
		traitsPageVC.setViewControllers([traitsVCs[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
		self.addChildViewController(traitsPageVC)
		self.view.addSubview(traitsPageVC.view)
	}
	
	func tappedNext(gestureRecognizer: UITapGestureRecognizer) {
		self.performSegueWithIdentifier("pushToCamera", sender: self)
		
		var traits = ""
		for button: ActivityView in activityArray {
			
			traits = traits.stringByAppendingString("\(button.iconView.selected.intValue)")
			
			
		}
		UserAccountController.sharedInstance.sendTraits(traits)
		bondLog("traits are \(traits)")
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		var index:Int! = find(traitsVCs, viewController as TraitArrayViewController)
		if (index == traitsVCs.count - 1) {
			return nil
		} else {
			return traitsVCs[index + 1]
		}
	}

	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		var index:Int! = find(traitsVCs, viewController as TraitArrayViewController)
		if (index == 0) {
			return nil
		} else {
			return traitsVCs[index - 1]
		}
	}

	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return traitsVCs.count
	}

	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return self.currentIndex
	}

	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
		if (completed) {
			self.currentIndex = self.nextIndex
		}
		self.nextIndex = self.currentIndex
	}

	func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
		var nextTraitVC = pendingViewControllers[0] as TraitArrayViewController
		self.nextIndex = find(traitsVCs, nextTraitVC)
	}
}