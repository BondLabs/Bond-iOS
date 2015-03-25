//
//  BondsDetailViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit
class BondsDetailViewController: UIViewController, UIScrollViewDelegate  {

	// Store id of relevant user
	var id:Int!
	var userID:Int!
	var name:String!
	var traits:String!
	var colorView: UIView!
	// Store view elements
	var scrollView: UIScrollView!
	var headerView: UIView!
	var placeholderHeaderView: UIImageView!
	var nameLabel: UILabel!
	var distLabel: UILabel!
	var profImage: CircleImageView!
	var actbuttons: NSMutableArray!
	var chatButton: UIButton!
	var barImageView: CircleImageView!
	//var gridView: KKGridView!
	var previousScrollViewYOffset: CGFloat = 0.0

	/* * *
	* * * Do basic setup-------------------------------------------------------
	* * */

	class var sharedInstance: BondsDetailViewController {
		struct Static {
			static var instance: BondsDetailViewController?
			static var token: dispatch_once_t = 0
		}

		dispatch_once(&Static.token) {
			Static.instance = BondsDetailViewController()
		}

		return Static.instance!
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		bondLog("Detail View Did Load")
		ViewManager.sharedInstance.currentViewController = self
		//UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)

		self.navigationItem.title = name
		var frame = CGRectMake(0,0,screenSize.width,200)



		self.colorView = UIView()
		colorView.frame.size = CGSizeMake(screenSize.width, 370)
		//colorView.center = CGPointMake(screenSize.width / 2, colorView.center.y)
		colorView.center.x = screenSize.width / 2
		//headerView.backgroundColor = UIColor.clearColor()

		//self.headerView = OverlayWindow(frame: frame)

		//self.placeholderHeaderView = NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(headerView)) as UIWindow


		//self.headerView.windowLevel = UIWindowLevelStatusBar
		//self.headerView.hidden = false
		//self.headerView.makeKeyAndVisible()



		self.headerView = UIView(frame: frame)
		//self.headerView.layer.borderColor = UIColor.blueColor().CGColor
		//self.headerView.layer.borderWidth = 5



		// Set up view properties
		self.scrollView = UIScrollView()
		self.scrollView.frame = self.view.bounds
		self.view.addSubview(scrollView)
		self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
		//self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
		self.scrollView.backgroundColor = UIColor.whiteColor()
		//self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
		self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.navigationController?.navigationBar.translucent = false
		// var name = "Test" // Get name of user using id
		self.navigationItem.title = self.name

		// Darker sub background
		var subBG = UIView()
		//subBG.backgroundColor = AppData.util.UIColorFromRGB(0x535353)
		subBG.backgroundColor = UIColor.whiteColor()
		subBG.layer.borderWidth = 0.5
		//subBG.layer.borderColor = UIColor.blackColor().CGColor
		subBG.layer.borderColor = UIColor.bl_altoColor().CGColor
		subBG.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.height)
		subBG.frame.origin = CGPointMake(0, self.view.frame.height)
		self.scrollView.addSubview(subBG)

		// Set up profile view for user using id
		bondLog("setting up bonds detailed for user with id \(self.id)")
		if (id != nil) {
			self.setup(id)
		} else {
			let alert = UIAlertView(title: "Opps", message: "An error has occured. If it persists, please report this to bugreport@bond.sh", delegate: nil, cancelButtonTitle: "Okay")
		}
	}

	/* * *
	* * * Add all elements to the profile page---------------------------------
	* * */

	func setup(id: Int) {
		// Get user details from id
		var name = "Kevin Zhang"
		var dist:Int! = 8
		var profPic:UIImage!
		//var activities:[String]! = ["Brainy", "Curious"]
		bondLog("traits are really \(self.traits)")
		//var combinedString = String()
		//let myTraits =
		let newTraits: String? = self.traits
		let myTraits = UserAccountController.sharedInstance.currentUser.traitsString
		let	combinedString = myTraits! & newTraits!

		var activities = BondBond.getTraitsFromString(combinedString) as [String]


		// Add a name label
		nameLabel = UILabel()
		nameLabel.text = name
		nameLabel.textColor = UIColor.bl_doveGrayColor()
		nameLabel.font = UIFont(name: "Helvetica-Bold", size: 24.0)
		nameLabel.frame.size = CGSizeMake(self.view.frame.width, 40)
		nameLabel.textAlignment = NSTextAlignment.Center
		nameLabel.center = CGPointMake(self.view.frame.width / 2, 280)
		self.headerView.addSubview(nameLabel)

		// Add profile picture
		profImage = CircleImageView()
		profImage.frame.size = CGSizeMake(160, 160)
		profImage.center = CGPointMake(self.view.frame.width / 2, 150)
		profImage.setDefaultImage(UIImage(named: "Profile(i).png")!)
		profImage.performSetup(1)
		//profImage.layer.borderColor = UIColor.blackColor().CGColor
		profImage.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
		profImage.layer.borderWidth = 1.0
		self.headerView.addSubview(profImage)


		self.barImageView = CircleImageView()

		let defaultImage = UIImage(named: "Profile(i).png")!
		profImage.frame.size = CGSizeMake(160, 160)
		barImageView.setDefaultImage(defaultImage)
		barImageView.performSetup(1)
		barImageView.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
		barImageView.layer.borderWidth = 1.0



		chatButton = UIButton()
		chatButton.frame.size = CGSize(width: 160.0, height: 40.0)
		chatButton.center = CGPointMake(self.view.frame.width / 2, 330)
		chatButton.backgroundColor = UIColor.bl_azureRadianceColor()
		chatButton.layer.cornerRadius = 20.0
		chatButton.layer.masksToBounds = true
		chatButton.userInteractionEnabled = true

		chatButton.setTitle("Messages", forState: UIControlState.Normal)
		chatButton.addTarget(self, action: "tappedButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.headerView.addSubview(chatButton)
		//let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedButton:")
		//chatButton.addGestureRecognizer(tapGestureRecognizer)

		// Add activity views

		/*
		var activityCount = min(activities.count, 4)
		for var i = 0; i < activityCount; i++ {

		var actView = ActivityView()
		actView.frame.size = CGSizeMake(70, 110)
		actView.setup(activities[i])
		var xfac:Float = (Float(i) + 0.5) / Float(activityCount)
		actView.center = CGPointMake(self.view.frame.width * CGFloat(xfac), self.view.frame.height * 3 / 5)

		self.scrollView.addSubview(actView)
		}
		*/
		actbuttons = NSMutableArray()


		bondLog("doing grid view thing")
		var actView: ActivityView? = ActivityView()
		actView!.frame.size = CGSizeMake(70, 110)
		//var activityCount = min(activities.count, 4)
		var activityCount = activities.count

		for var i = 0; i < activityCount; i++ {
			var actView = ActivityView()
			actView.frame.size = CGSizeMake(70, 110)
			actView.setup(activities[i])
			let index = i + 1
			actbuttons.addObject(actView)
		}

		var frame = CGRectMake(0,0,screenSize.width,225)

		let gridHeaderView = UIView(frame: frame)
		gridHeaderView.backgroundColor = UIColor.clearColor()


		//MARK: Also Grid View implementation

		/*gridView = KKGridView(frame: CGRectMake(0,150, self.view.frame.size.width, self.view.frame.size.height - 190))
		gridView.center = CGPointMake(screenSize.width / 2 , gridView.center.y)
		gridView.cellSize = CGSizeMake(screenSize.width / 3 - 10, 110.0);

		//gridView.cellPadding = CGSizeMake((screenSize.width - ((screenSize.width / 4) * 3)) / 3, 4.0);
		gridView.cellPadding = CGSizeMake(3 + 1/3 , 4.0)
		let combinedCellSize =  (CGFloat(3) * gridView.cellSize.width)
		let combinedSpaceSize = (CGFloat(2) * gridView.cellPadding.width)
		let edgeBorders = (screenSize.width - combinedCellSize - combinedSpaceSize)
		gridView.frame.origin.x = edgeBorders
		gridView.allowsMultipleSelection = false
		//gridView.autoresizingMask = UIViewAutoresizing.FlexibleWidth// | UIViewAutoresizing.FlexibleHeight;
		gridView.delegate = self
		gridView.gridHeaderView = gridHeaderView
		gridView.dataSource = self
		gridView.layer.shouldRasterize = true
		gridView.layer.rasterizationScale = 2



		self.view.addSubview(gridView)
		self.view.insertSubview(self.headerView, aboveSubview: gridView)
		*/

		self.colorView.backgroundColor = UIColor.bl_backgroundColorColor()
		self.colorView.layer.borderWidth = 1
		self.colorView.layer.borderColor = UIColor.bl_altoColor().CGColor
		//self.colorView.alpha = 0.0
		//self.view.insertSubview(self.colorView, aboveSubview: gridView)
		//headerView.addSubview(colorView)


		//MARK: Grid View Implementation

		/*
		for var i = 0; i < activityCount; i++ {
		var actView = ActivityView()
		actView.frame.size = CGSizeMake(70, 110)

		let index = i + 1

		actView.setup(activities[i])
		let perRow = 3
		let rawNumberOfRows = (CGFloat(activityCount) / CGFloat(perRow))
		let numberOfRows = ceil(rawNumberOfRows)
		let rawRow = ((CGFloat(index) / CGFloat(activityCount)) * CGFloat(numberOfRows))
		let row = ceil(rawRow)
		let amountUpToRow = (CGFloat(perRow) * CGFloat(row))
		let positionInRow = (Float(CGFloat(index) - amountUpToRow) + Float(perRow - 1)) //(CGFloat(perRow) - (CGFloat(amountUpToRow) - CGFloat(i + 1)))


		bondLog("\(index) total amount is \(activityCount)")
		bondLog("\(index) per row is \(perRow)")
		bondLog("\(index) raw numberOfRows is \(rawNumberOfRows)")
		bondLog("\(index) numberOfRows is \(numberOfRows)")
		bondLog("\(index) raw row is \(rawRow)")
		bondLog("\(index) row is \(row)")
		bondLog("\(index) amountUpToRow is \(amountUpToRow)")
		bondLog("\(index) position in row is \(positionInRow)")






		var xfac:CGFloat = (CGFloat(positionInRow) + 0.5) / CGFloat(min(activityCount, perRow))


		let yOffset = CGFloat(120 * (row - 1))

		let viewWidth = CGFloat(self.view.frame.width)

		let center = (Float(self.view.frame.height * CGFloat(perRow)) / 5)
		let theRealYOffset = CGFloat(CGFloat(yOffset) + CGFloat(center))
		let centerX = ((CGFloat(viewWidth) * CGFloat(xfac)))
		let centerY = CGFloat(center) + yOffset
		actView.center = CGPointMake(centerX, centerY)

		bondLog("actView \(i) center is \(actView.center)")
		self.scrollView.addSubview(actView)
		actbuttons.addObject(actView)
		self.scrollView.contentSize.height = self.view.frame.size.height + yOffset
		}
		*/


	}
	/*override func prefersStatusBarHidden() -> Bool {
	return false
	}*/





	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

	func tappedButton(sender: UITapGestureRecognizer) {

		ViewManager.sharedInstance.ProgressHUD = nil

		ViewManager.sharedInstance.ProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
		ViewManager.sharedInstance.ProgressHUD!.mode = MBProgressHUDModeCustomView
		let gmailView = GmailLikeLoadingView(frame: CGRectMake(0, 0, 40, 40))
		gmailView.startAnimating()
		ViewManager.sharedInstance.ProgressHUD!.customView = gmailView
		ViewManager.sharedInstance.ProgressHUD!.labelText = "Loading"
		UserAccountController.sharedInstance.getChat(self.id, authKey:UserAccountController.sharedInstance.currentUser.authKey)

		ViewManager.sharedInstance.chatViewController = nil

		let vc = ChatViewController()
		vc.barTitle = self.name
		vc.chatBondID = self.id
		vc.delegate = self
		ViewManager.sharedInstance.chatViewController = vc
		bondLog("tapped Chat Button")
	}

	//MARK: Grid View Delegate Functions


	/*func gridView(gridView: KKGridView!, numberOfItemsInSection section: UInt) -> UInt {

		let newTraits: String? = self.traits
		let myTraits = UserAccountController.sharedInstance.currentUser.traitsString
		let	combinedString = myTraits! & newTraits!
		var activities = BondBond.getTraitsFromString(combinedString) as [String]
		var activityCount = activities.count
		return UInt(activityCount - 1)
	}

	func gridView(gridView: KKGridView!, cellForItemAtIndexPath indexPath: KKIndexPath!) -> KKGridViewCell! {
		//let cell = KKGridViewCell(frame: CGRectMake(0,0,70,70))
		let cell = KKGridViewCell.cellForGridView(gridView) as KKGridViewCell

		let i = Int(indexPath.index)
		let actView: ActivityView? = actbuttons[i] as? ActivityView
		for view in cell.contentView.subviews {
			view.removeFromSuperview()
		}
		cell.contentView.addSubview(actView!)
		//cell.contentView = actView!
		return cell

	}

*/


	func scrollViewDidScroll(scrollView: UIScrollView) {
		//var frame = self.navigationController!.navigationBar.frame;
		var headerFrame = self.headerView.frame
		var headerTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
		headerFrame.origin.y = 0
		//let size = frame.size.height - 21;
		let headerSize = CGFloat(40)


		let scrollOffset = scrollView.contentOffset.y;
		let scrollDiff = scrollOffset - self.previousScrollViewYOffset;
		let scrollHeight = scrollView.frame.size.height;
		let scrollContentSize = scrollView.contentSize.height
		let scrollContentSizeHeight = scrollView.contentSize.height// + scrollView.contentInset.bottom;


		let percentScrolled = 1 - (min(scrollOffset,300) / 300)


		if (scrollOffset <= -scrollView.contentInset.top) {

			headerTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
			UIView.animateWithDuration(0.05, animations: {() -> Void in
			self.nameLabel.alpha = 1
			self.chatButton.alpha = 1
			self.colorView.frame.size.height = 370
			})

		} else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {

			headerTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5)
			UIView.animateWithDuration(0.1, animations: {() -> Void in
			self.nameLabel.alpha = 0
			self.chatButton.alpha = 0
			self.colorView.frame.size.height = 150
				//headerFrame.origin.y = 6
			})
		} else {

			headerTransform = CGAffineTransformScale(CGAffineTransformIdentity, max(percentScrolled, 0.5), max(percentScrolled, 0.5))
			headerFrame.origin.y = max(percentScrolled, 0.5) * -50 + 56

				self.nameLabel.alpha = (max(percentScrolled - 0.5,0) * 2)
				self.chatButton.alpha = (max(percentScrolled - 0.5,0) * 2)
				self.colorView.frame.size.height = max(370 - scrollOffset, 150)


			let offset = ((400 - min(scrollOffset,400)) - 200) * 2

		}


		UIView.animateWithDuration(0.1, animations: {() -> Void in
			self.headerView.frame = headerFrame
			self.headerView.transform = headerTransform
		})
		self.previousScrollViewYOffset = scrollOffset;
	}
	
	
}