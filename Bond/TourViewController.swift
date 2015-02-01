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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var tourPageVC:UIPageViewController!
    var pageControl:UIPageControl!
    var tourViewFrame:CGRect!
    var tourVCs:[UIViewController]!
    var currentIndex:Int! = 0
    var nextIndex:Int!
    var viewBounds:CGSize!
    var nextButton:UIButton!
    
    /* * *
    * * * Initial setup of the view--------------------------------------------
    * * */
    
    // Initial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = false
        self.view.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        
        /* * *
        * * * Do basic setup---------------------------------------------------
        * * */
        
        // Set current view controller
        ViewManager.sharedInstance.currentViewController = self
        
        // Unhide navigation bar if hidden
        self.navigationController?.navigationBarHidden = true
        
        // Store view dimensions
        viewBounds = self.view.frame.size
        
        /* * *
        * * * Set up activity views and page controller -----------------------
        * * */
        
        // Initialize page view controller
        tourPageVC = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        tourPageVC.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 50)
        tourViewFrame = CGRect(origin: CGPointZero, size: CGSizeMake(tourPageVC.view.frame.width, tourPageVC.view.frame.height - AppData.data.heights.pageControlHeight))
        tourPageVC.delegate = self
        tourPageVC.dataSource = self
        
        // Set up page control
        pageControl = UIPageControl()
        pageControl.numberOfPages = 6
        pageControl.currentPage = 0
        pageControl.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 86)
        self.view.addSubview(pageControl)
        
        // Create and store all view controllers to be shown
        var viewCount = 6
        
        // Set up tourVCs
        var tour_1 = Tour_BondViewController()
        tour_1.setup(tourViewFrame)
        var tour_2 = Tour_PeopleViewController()
        tour_2.setup(tourViewFrame)
        var tour_3 = Tour_TraitsViewController()
        tour_3.setup(tourViewFrame)
        var tour_4 = Tour_BondingViewController()
        tour_4.setup(tourViewFrame)
        var tour_5 = Tour_ChatViewController()
        tour_5.setup(tourViewFrame)
        var tour_6 = Tour_StartViewController()
        tourVCs = [tour_1, tour_2, tour_3, tour_4, tour_5, tour_6]
        
        // Set up and add page view controller
        tourPageVC.setViewControllers([tourVCs[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.addChildViewController(tourPageVC)
        self.view.addSubview(tourPageVC.view)
        
        // Set up next button
        nextButton = UIButton()
        nextButton.setTitle("Next 〉", forState: UIControlState.Normal)
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.titleLabel!.font = UIFont(name: "Avenir-Medium", size: 18.0)!
        nextButton.setTitleColor(AppData.util.UIColorFromRGB(0x00A4FF), forState: UIControlState.Normal)
        nextButton.frame.size = CGSizeMake(self.view.frame.width, 50)
        nextButton.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 25)
        self.view.addSubview(nextButton)
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "nextTapped"))
        
        // Initialize signup button
        signupButton.backgroundColor = AppData.util.UIColorFromRGB(0x00A4FF)
        signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
        signupButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signupButton.frame = CGRectMake(0, self.view.frame.height - 50, self.view.frame.width / 2, 50)
        signupButton.alpha = 0
        signupButton.userInteractionEnabled = false
        
        // Initialize login button
        loginButton.backgroundColor = AppData.util.UIColorFromRGB(0xFFFFFF)
        loginButton.setTitle("Log In", forState: UIControlState.Normal)
        loginButton.setTitleColor(AppData.util.UIColorFromRGB(0x00A4FF), forState: UIControlState.Normal)
        loginButton.frame = CGRectMake(self.view.frame.width / 2, self.view.frame.height - 50, self.view.frame.width / 2, 50)
        loginButton.alpha = 0
        loginButton.userInteractionEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    func showStartButtons() {
        UIView.animateWithDuration(0.5, animations: {
            self.nextButton.alpha = 0
            self.signupButton.alpha = 1.0
            self.loginButton.alpha = 1.0
            }, completion: { finished in
                self.nextButton.userInteractionEnabled = false
                self.signupButton.userInteractionEnabled = true
                self.loginButton.userInteractionEnabled = true
        })
    }
    
    func hideStartButtons() {
        UIView.animateWithDuration(0.5, animations: {
            self.nextButton.alpha = 1.0
            self.signupButton.alpha = 0
            self.loginButton.alpha = 0
            }, completion: { finished in
                self.nextButton.userInteractionEnabled = true
                self.signupButton.userInteractionEnabled = false
                self.loginButton.userInteractionEnabled = false
        })
    }
    
    func nextTapped() {
        for var i = 0; i < tourVCs.count; i++ {
            if tourVCs[i] as UIViewController == tourPageVC.viewControllers[0] as UIViewController {
                if (i < tourVCs.count - 1) {
                    tourPageVC.setViewControllers([tourVCs[i+1]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                    pageControl.currentPage = i+1
                    println("setting page \(i+1)")
                    if (i != tourVCs.count - 2) {
                        self.hideStartButtons()
                    } else {
                        self.showStartButtons()
                    }
                    return
                }
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index:Int! = find(tourVCs, viewController as UIViewController)
        println("Going forwards \(index)")
        if (index == tourVCs.count - 1) {
            return nil
        } else {
            pageControl.currentPage = index + 1
            if index + 1 == tourVCs.count - 1 {
                self.showStartButtons()
            }
            return tourVCs[index + 1]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index:Int! = find(tourVCs, viewController as UIViewController)
        println("Going backwards \(index)")
        if (index == 0) {
            return nil
        } else {
            pageControl.currentPage = index - 1
            if index != tourVCs.count - 1 {
                self.hideStartButtons()
            }
            return tourVCs[index - 1]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (completed) {
            self.currentIndex = self.nextIndex
        }
        self.nextIndex = self.currentIndex
        pageControl.currentPage = self.currentIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        var nextTourVC = pendingViewControllers[0] as UIViewController
        self.nextIndex = find(tourVCs, nextTourVC)
    }
}