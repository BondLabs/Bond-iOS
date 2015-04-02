//
//  BondsViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondsViewController: UITableViewController {

	// Store bonds as a property of the controller
	//let YES = true
	//let NO = false
	var bonds:[String]!
	var bondArray:[String]!
	var bondIDArray:[String]!
	var bondTraitsDict = NSMutableDictionary()

	/* * *
	* * * Do basic setup
	* * */

	override func viewDidLoad() {
		super.viewDidLoad()

		ViewManager.sharedInstance.currentViewController = self
		let UAC = UserAccountController.sharedInstance

		// Get bonds from online
		AppData.bondLog("items in array \(UAC.currentUser.bonds)")
		bondArray = UAC.currentUser.bonds.allValues as [String]
		bondIDArray = UAC.currentUser.bonds.allKeys as [String]
		AppData.bondLog("all items in bond array \(bondArray)")

		//let bondData = UserAccountController.sharedInstance.getBonds(UserAccountController.sharedInstance.currentUser.userID, authKey: UserAccountController.sharedInstance.currentUser.authKey)
		//AppData.bondLog("\(bondData)")
		bonds = ["Kevin Zhang", "Daniel Singer", "Jason Fieldman"]

		// Customize view and navigation bar
		//self.view.backgroundColor = AppData.util.UIColorFromRGB(0x4A4A4A)
		//self.view.backgroundColor = UIColor.bl_backgroundColorColor()
		self.view.backgroundColor = AppData.util.UIColorFromRGB(0xF1F1F1)
		self.tableView.separatorColor = UIColor.bl_altoColor()
		self.navigationItem.title = "Bonds"
		//self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
		self.navigationController?.navigationBar.barTintColor = UIColor.bl_azureRadianceColor()
		self.tableView.tableFooterView = UIView()

		// Set row height
		self.tableView.rowHeight = 60.0

		// Add "no content" labels if no bonds
		if self.bondArray.count == 0
		{
			var noBondsImage = UIImage(named: "No Bonds Image.png")!
			var scale = self.view.frame.width / 750
			self.view.backgroundColor = UIColor(patternImage: AppData.util.scaleImage(noBondsImage, size: noBondsImage.size, scale: scale))
		} else {
			//self.view.backgroundColor = UIColor.whiteColor()
			self.view.backgroundColor = UIColor.bl_backgroundColorColor()
		}

		getBondImages()

		getBondTraits()


	}

	override func viewDidAppear(animated: Bool) {
		self.tableView.reloadData()
	}

	/* * *
	* * * Getting images for bonds
	* * */

	func getBondImages() {
		/*
		for (bid, name) in UserAccountController.sharedInstance.currentUser.bonds {
		AppData.bondLog("getBondImages(): \(bid)")
		UserAccountController.sharedInstance.getOtherUserPhoto(bid.integerValue, authKey: UserAccountController.sharedInstance.currentUser.authKey)
		}
		*/
	}

	func getBondTraits() {


		for (bid, name) in UserAccountController.sharedInstance.currentUser.bonds {
			AppData.bondLog("getBondTraits(): \(bid)")
			let userID = UserAccountController.sharedInstance.userIDForBondID(bid.integerValue, authKey: UserAccountController.sharedInstance.currentUser.authKey)

			let traitsDict = UserAccountController.sharedInstance.getAndReturnTraits(userID, authKey: UserAccountController.sharedInstance.currentUser.authKey)

			bondLog("got a traits dict response - It's \(traitsDict)")

			if traitsDict.objectForKey("error") == nil {
				bondTraitsDict.setObject((traitsDict.objectForKey("traits") as NSString).safeUnwrap(), forKey: "\(userID)")
			}
			else {
				bondTraitsDict.setObject("000000000000000000000000000000000000000000000", forKey: "\(userID)")
			}

			bondLog("Traits: \(UserAccountController.sharedInstance.getAndReturnTraits(bid.integerValue, authKey: UserAccountController.sharedInstance.currentUser.authKey))")
		}
		bondLog("Bond traits are \(bondTraitsDict)")
	}






	/* * *
	* * * Function necessary for tableview
	* * */

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bondArray.count
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("BondTableCell", forIndexPath: indexPath) as BondTableCell
		if !cell.hasBeenSetUp {
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedCell:")
			cell.addGestureRecognizer(tapGestureRecognizer)

				cell.bondID = bondIDArray[indexPath.row]


				cell.userID = UserAccountController.sharedInstance.userIDForBondID(cell.bondID.toInt()!, authKey: UserAccountController.sharedInstance.currentUser.authKey)

			cell.traits = bondTraitsDict.objectForKey("\(cell.userID)") as String
			AppData.bondLog("all items in bond array \(bondArray[indexPath.row])")
			let name: String = UserAccountController.sharedInstance.currentUser.bonds.objectForKey(bondIDArray[indexPath.row]) as String
			cell.setup(name)
			

		}
		return cell
	}
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			// Delete the row from the data source
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			bonds.removeAtIndex(indexPath.row)
		}
	}

	func tappedCell(sender: UIGestureRecognizer) {

		let senderCell: BondTableCell = sender.view as BondTableCell
		bondLog("tapped cell for \(senderCell.name)")
        
		//self.navigationController?.pushViewController(vc, animated: true)
        performSegueWithIdentifier("segueToDetail", sender: senderCell)
		bryceLog("pushing VC (betterbondvc) from \(self)")
	}

	override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
		var temp:String!
		temp = bonds[toIndexPath.row]
		bonds[fromIndexPath.row] = bonds[toIndexPath.row]
		bonds[toIndexPath.row] = temp
		tableView.reloadData()
	}

	// Pass bond id to the detailed controller

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "ShowBondDetail") {
			(segue.destinationViewController as BetterBondDetailViewController).id = 1
			(segue.destinationViewController as BetterBondDetailViewController).name = (sender as BondTableCell).name // Set id of bond here
		}
        
        if let des = segue.destinationViewController as? BetterBondDetailViewController {
            let senderCell = sender as BondTableCell
            
            bondLog("bond traits dict is \(bondTraitsDict)")
            des.traits = bondTraitsDict.objectForKey("\(senderCell.userID)") as String
            des.id = senderCell.userID
            bondLog("View controller ID is \(des.id)")
            des.view.frame = self.view.frame
            des.nameLabel.text = senderCell.name
            des.name = senderCell.name
            bondLog("setting traits to \(bondTraitsDict.objectForKey(senderCell.bondID))")
            
            bondLog("traits were set to \(des.traits)")
            
        }
	}

	/* * *
	* * * Change tableview aesthetics
	* * */

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		// Remove seperator inset
		cell.separatorInset = UIEdgeInsetsZero

		// Prevent the cell from inheriting the Table View's margin settings
		cell.preservesSuperviewLayoutMargins = false

		// Explictly set your cell's layout margins
		cell.layoutMargins = UIEdgeInsetsZero
	}
    

	
}
