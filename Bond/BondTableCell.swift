//
//  BondTableCell.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondTableCell: UITableViewCell {

	// Store name of the user
	var name:String!
	var bondID:String!
	var userID:Int!
	var traits:String!
	var cachedImage: UIImage!
	var hasBeenSetUp = false
	var profImageView:ParseCircleImageView = ParseCircleImageView()

	/* * *
	* * * Do setup
	* * */

	func setup(id: String) {



		let backgroundView = UIView(frame: self.frame)
		backgroundView.backgroundColor = AppData.util.UIColorFromRGB(0xF1F1F1)
		self.selectedBackgroundView = backgroundView
		self.contentView.backgroundColor = UIColor.whiteColor()
		// Set up basic properties
		//self.backgroundColor = AppData.util.UIColorFromRGB(0x404040)
		self.backgroundColor = UIColor.whiteColor()
		// Get profile pic
		self.name = id
		//var profPic:UIImage = self.getProfPic()
		let image = UIImage(named: "Profile(i).png")!
		getProfPic()
		// Create a circle image view
		//var profImageView:CircleImageView = CircleImageView()
		//self.setImage(UIImage(named: "Profile(i).png")!)
		self.profImageView.backgroundColor = UIColor.bl_azureRadianceColor()
		let query = PFQuery(className: "photos")
		let userIDString = NSString(format: "%d", self.userID)
		query.whereKey("User", equalTo: "\(self.userID)")
		query.orderByDescending("createdAt")
		query.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
			if error == nil {
				let file = object?.objectForKey("photo") as PFFile
				self.profImageView.file = file
				self.profImageView.loadInBackground({ (image: UIImage!, error: NSError!) -> Void in

					self.setImage(image)
				})
			}
			else {
				bondLog("error getting image file")

			}
		}
		profImageView.frame.size = CGSizeMake(45, 45)
		profImageView.center = CGPointMake(30, 30)
		//profImageView.setDefaultImage(image)
		profImageView.performSetup(0.5)
		profImageView.addBorder(0x00A4FF)
		if profImageView.superview == nil {
			self.addSubview(profImageView)
		}

		// Add a name label
		var nameLabel = UILabel()
		nameLabel.text = name
		nameLabel.font = UIFont(name: "Avenir-Medium", size: 20.0)

		nameLabel.sizeToFit()
		nameLabel.frame.origin = CGPointMake(60, 8)
		var center = nameLabel.center
		center.y = self.bounds.size.height / 2
		nameLabel.center = center
		//nameLabel.textColor = UIColor.whiteColor()
		nameLabel.textColor = UIColor.bl_doveGrayColor()
		if nameLabel.superview == nil {
			self.addSubview(nameLabel)
		}

		// TODO: Get time
		srand48(0)
		var time:Int! = Int(drand48() * 100000)
		var tdenom:String!
		if (time > 365 * 24) {
			tdenom = "y"
			time = Int(time / 365 / 24)
		} else if (time > 30 * 24) {
			tdenom = "m"
			time = Int(time / 30 / 24)
		} else if (time > 7 * 24) {
			tdenom = "d"
			time = Int(time / 7 / 24)
		} else {
			tdenom = "h"
		}
		var timeLabel = UILabel()
		timeLabel.text = "\(time)\(tdenom)"
		timeLabel.font = UIFont(name: "Avenir-Book", size: 9.0)
		timeLabel.textColor = UIColor.whiteColor()
		timeLabel.sizeToFit()
		timeLabel.center = CGPointMake(self.frame.width - 15, 30)
		self.addSubview(timeLabel)

		self.hasBeenSetUp = true
	}

	func setImage(image: UIImage?) {
		var imageSize = CGSizeMake(45,45)
		var const = CGFloat(1)
		if image?.size.height < image?.size.width {
			const = CGFloat(45) / image!.size.height
		}
		else if image?.size.height > image?.size.width {
			const = CGFloat(45) / image!.size.width
		}
		imageSize.height = max(image!.size.height * const, 45)
		imageSize.width = max(image!.size.width * const, 45)






		let newImage = image != nil ? image! : UIImage(named: "Profile(i).png")!



		self.profImageView.image = AppData.util.scaleImage(newImage, size: imageSize, scale: 1)

		self.profImageView.layer.masksToBounds = true

	}


	func getProfPic() { //-> UIImage {


		//UserAccountController.sharedInstance.getOtherUserImageAsync(self.userID, passthroughImageView: profImageView)
		/*
		if self.cachedImage == nil {
		UserAccountController.sharedInstance.getOtherUserPhoto(self.userID, authKey: UserAccountController.sharedInstance.currentUser.authKey, passthroughImageView: profImageView, cell:self)
		}
		else {
		self.profImageView.image = self.cachedImage
		}
		*/

		// Use this to get the profile picture for the bond
		/*var image = UIImage(named: "Profile(i).png")!

		if (UserAccountController.sharedInstance.otherUserImages.allKeys.count > 0){
		bondLog(_stdlib_getTypeName(UserAccountController.sharedInstance.otherUserImages.allKeys[0]))
		}

		if UserAccountController.sharedInstance.otherUserImages.objectForKey(self.bondID.toInt()!) != nil
		{
		image = UserAccountController.sharedInstance.otherUserImages.objectForKey(self.bondID.toInt()!) as UIImage
		}else{
		bondLog("IMAGE IS NIL BOND ID IS: \(self.bondID as String)")
		//            bondLog("other user images is: \(UserAccountController.sharedInstance.otherUserImages)")
		
		}
		return image
		*/
	}
	
}
