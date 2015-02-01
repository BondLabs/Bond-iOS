//
//  TourViewController.swift
//  Bond
//
//  Created by Bond on 1/31/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class TourViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    /* * *
    * * * View properties------------------------------------------------------
    * * */
    
    // View components
    var nextButton: UIButton!
    var tourPageVC:UIPageViewController!
    var tourViewFrame:CGRect!
    var tourVCs:[UIViewController]!
    var currentIndex:Int! = 0
    var nextIndex:Int!
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
        
        // Store view dimensions
        viewBounds = self.view.frame.size
        
        // Hide navigation bar and set title
        self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
        self.navigationController?.navigationBar.hidden = true
        
        // Set up nextButton
        self.nextButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        self.nextButton.frame = CGRectMake(0, viewBounds.height - 50, viewBounds.width, 50)
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.nextButton.setTitle("Next 〉", forState: UIControlState.Normal)
        self.nextButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18.0)
        
        /* * *
        * * * Set up activity views and page controller -----------------------
        * * */
        
        // Initialize page view controller
        tourPageVC = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        tourPageVC.view.frame = CGRectMake(0, 50, self.view.frame.width, self.view.frame.height - 100)
        tourViewFrame = CGRect(origin: CGPointZero, size: CGSizeMake(tourPageVC.view.frame.width, tourPageVC.view.frame.height - AppData.data.heights.pageControlHeight))
        
        // Create and store all view controllers to be shown
        var viewCount = 5
        
        // Set up and add page view controller
        tourPageVC.setViewControllers([tourVCs[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.addChildViewController(tourPageVC)
        self.view.addSubview(tourPageVC.view)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index:Int! = find(tourVCs, viewController as UIViewController)
        if (index == tourVCs.count - 1) {
            return nil
        } else {
            return tourVCs[index + 1]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index:Int! = find(tourVCs, viewController as UIViewController)
        if (index == 0) {
            return nil
        } else {
            return tourVCs[index - 1]
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return tourVCs.count
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
        var nextTourVC = pendingViewControllers[0] as UIViewController
        self.nextIndex = find(tourVCs, nextTourVC)
    }
}