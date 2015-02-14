//
//  ChatViewController.swift
//  Bond
//
//  Created by Bryce Dougherty on 1/31/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class ChatViewController: SOMessagingViewController, SOMessagingDataSource, SOMessagingDelegate {
    
    let NO = false
    let YES = true
    var myImage: UIImage!
    var barTitle: String!
    var chatBondID: Int!
    var partnerImage: UIImage!
    var dataSource: NSMutableArray!
    var tableViewHeaderView: UIView!
	var noChatsView: UIImageView!
	var delegate: UIViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadMessages()
		
		// Create image for background
		let unscaledBg = UIImage(named: "bg@2x.png")!
		UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
		var context = UIGraphicsGetCurrentContext()
		unscaledBg.drawInRect(CGRect(origin: CGPointZero, size: self.view.frame.size))
		// Darken background
		UIColor(red: 30/256, green: 30/256, blue: 30/256, alpha: 0.75).setFill()
		CGContextFillRect(context, self.view.frame)
		var bgImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.view.backgroundColor = UIColor(patternImage: bgImage)
		
		// Add name label to view
		
		// Set up tableview
		self.tableView.frame = CGRectMake(0, 70, self.view.frame.width, self.view.frame.height - 70)
		self.tableView.backgroundColor = UIColor.clearColor()
		self.tableView.dataSource = self
		self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
		
		// Set up table header
		self.tableViewHeaderView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 0.01))
		self.tableViewHeaderView.backgroundColor = UIColor.clearColor()
		self.tableView.tableHeaderView = self.tableViewHeaderView
		self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		
		// Set up input view
		self.inputView = SOMessageInputView()
		self.inputView.delegate = self
		self.inputView.tableView = self.tableView
		self.inputView.adjustPosition()
		
		let contentOffset = CGPoint(x: 0, y: self.tableView.contentSize.height)
		self.tableView.contentOffset = contentOffset
		
		// Add no chats yet if no chats
		if self.dataSource.count == 0 {
			if self.noChatsView == nil {
				var noChatsImage = UIImage(named: "No Chat Image.png")!
				noChatsImage = AppData.util.scaleImage(noChatsImage, size: noChatsImage.size, scale: 0.5)
				noChatsView = UIImageView()
				noChatsView.image = noChatsImage
				noChatsView.sizeToFit()
				noChatsView.center = CGPointMake(self.view.frame.width / 2, 250)
			}
			self.view.addSubview(noChatsView)
		}
		
		//UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)

	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
		
		var nameLabel = UILabel()
		nameLabel.text = barTitle
		nameLabel.textColor = UIColor.whiteColor()
		nameLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
		nameLabel.sizeToFit()
		nameLabel.center = CGPointMake(self.view.frame.width / 2, 45)
		
		self.view.addSubview(nameLabel)
		
		var closeButton = UIButton()
		closeButton.setImage(UIImage(named: "Cancel"), forState: UIControlState.Normal)
		var rekt = closeButton.frame
		rekt.size = CGSizeMake(20, 20)
		closeButton.frame = rekt
		closeButton.center = CGPointMake(self.view.frame.width - 30, 45)
		closeButton.addTarget(self, action: "tappedName:", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(closeButton)
		
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
    func tappedName(sender: UIGestureRecognizer) {
		bondLog("tapped Close Button in Chat")
/*
		self.dismissViewControllerAnimated(true, completion: {() -> Void in
			bondLog("view controller dismissed")
			})
*/
		//self.delegate.navigationController?.popViewControllerAnimated(true)
		//self.delegate.navigationController?.popToViewController(self.delegate, animated: true)
		self.presentingViewController?.dismissViewControllerAnimated(true, completion: {() -> Void in
			bondLog("view controller dismissed")
		})
    }
    
    func loadMessages () {
        self.dataSource = ChatContentManager.sharedManager.generateConversation().mutableCopy() as NSMutableArray
    }
    
    override func messages() -> NSMutableArray! {
        return self.dataSource
    }
    
	override func heightForMessageForIndex(index: Int) -> CGFloat {
		var height = super.heightForMessageForIndex(index)

		let message: Message = self.messages()[index] as Message
		let shouldBeMessageHeight = AppData.util.getHeightForText(message.text, font: self.messageFont(), size: CGSizeMake(self.messageMaxWidth(), CGFloat.max))
		let fromMeThingLast = (message.fromMe) && (index == self.dataSource.count - 1  || (index != 0 && !(self.dataSource[index + 1] as Message).fromMe))
		let notFromMeThingLast = (!message.fromMe) && (index == self.dataSource.count - 1 || (index != 0 && (self.dataSource[index + 1] as Message).fromMe))

		if height > shouldBeMessageHeight.height {

			if fromMeThingLast || notFromMeThingLast {
				return (shouldBeMessageHeight.height + 40)
			}
			else {
				return (shouldBeMessageHeight.height + 10)
			}
		}
		else {

			if fromMeThingLast || notFromMeThingLast {
				return height + 40
			}
			else {
				return height - 10
			}
		}
	}
    
    override func configureMessageCell(cell: SOMessageCell, forMessageAtIndex index: Int) {
        let message:Message = self.dataSource[index] as Message
		
		println(message.text)

		let nameSize = AppData.util.getWidthForText((split(UserAccountController.sharedInstance.currentUser.name as String) {$0 == " "})[0], font: UIFont(name: "Avenir-Heavy", size: 18.0)!, size: CGSizeMake(CGFloat.max, cell.frame.size.height))
		bryceLog("\(nameSize)")
		
        if message.fromMe {
			cell.textView.textAlignment = NSTextAlignment.Right
			if index == 0  || (index != 0 && !(self.dataSource[index - 1] as Message).fromMe) {
				cell.userNameLabel.text = (split(UserAccountController.sharedInstance.currentUser.name as String) {$0 == " "})[0]
				cell.userNameLabel.sizeToFit()
				cell.userNameLabel.font = UIFont(name: "Avenir-Heavy", size: 18.0)
				cell.userNameLabel.frame.size = CGSizeMake(self.view.frame.width - 20, cell.userNameLabel.frame.size.height)
				cell.userNameLabel.frame.origin = CGPointMake(-(nameSize.width + 70), 10)
				cell.userNameLabel.textColor = UIColor(red: 0/255, green: 164/255, blue: 255/255, alpha: 1)
				cell.userNameLabel.textAlignment = NSTextAlignment.Right
				cell.textView.textAlignment = NSTextAlignment.Right
				cell.frame.size = CGSizeMake(cell.frame.size.width, cell.frame.size.height + 40)
			}
		} else {
			cell.textView.textAlignment = NSTextAlignment.Left
			if index == 0 || (index != 0 && (self.dataSource[index - 1] as Message).fromMe) {
				cell.userNameLabel.text = (split(barTitle) {$0 == " "})[0]
				cell.userNameLabel.sizeToFit()
				cell.userNameLabel.font = UIFont(name: "Avenir-Heavy", size: 18.0)
				cell.userNameLabel.frame.size = CGSizeMake(self.view.frame.width - 20, cell.userNameLabel.frame.size.height)
				cell.userNameLabel.frame.origin = CGPointMake(10, 10)
				cell.userNameLabel.textColor = UIColor(red: 189/255, green: 16/255, blue: 244/255, alpha: 1)
				cell.userNameLabel.textAlignment = NSTextAlignment.Left
				cell.frame.size = CGSizeMake(cell.frame.size.width, cell.frame.size.height + 40)
			}
        }
		
        if (!message.fromMe) {
            cell.contentInsets = UIEdgeInsetsMake(0, 4.0, 0, 0) //Move content for 4 pt. to right
        } else {
            cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 4.0) //Move content for 4 pt. to left
        }
        cell.backgroundColor = UIColor.clearColor()
        cell.textView.frame = CGRectOffset(cell.textView.frame, 0, 30)
        cell.textView.textColor = UIColor.whiteColor()
        cell.userImageView.layer.cornerRadius = 3
        cell.userImageView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
        
        if (message.fromMe == true) {
            cell.userImage = self.myImage
        } else {
            cell.userImage = self.partnerImage
        }
        
        cell.panGesture.enabled = NO
        generateLabelForCell(cell)
    }
    
    func generateLabelForCell(cell: SOMessageCell) {
		
    }
    
    override func balloonImageForSending() -> UIImage! {
        let img = UIImage(named: "bubble_rect_sending.png")
        return img?.resizableImageWithCapInsets(UIEdgeInsetsMake(3, 3, 24, 11))
    }
    
    override func balloonImageForReceiving() -> UIImage! {
        let img = UIImage(named: "bubble_rect_receiving.png");
        return img?.resizableImageWithCapInsets(UIEdgeInsetsMake(3, 11, 24, 3));
    }
    
    override func messageMaxWidth() -> CGFloat {
        return 140
    }
    
    override func userImageSize() -> CGSize {
        return CGSizeMake(60,60)
    }
    
    override func balloonMinHeight() -> CGFloat {
        return 60
    }
    
    override func balloonMinWidth() -> CGFloat {
        return 243
    }
    
    override func didSelectMedia(media: NSData, inMessageCell cell: SOMessageCell!) {
        super.didSelectMedia(media, inMessageCell: cell)
    }
    
    override func messageInputView(inputView: SOMessageInputView, didSendMessage message: String) {
        if (message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).utf16Count == 0) {
            return
        }
        
        UserAccountController.sharedInstance.newChat(chatBondID, userID: UserAccountController.sharedInstance.currentUser.userID, message: message, authKey: UserAccountController.sharedInstance.currentUser.authKey)
        let msg = Message()
        msg.text = message
        msg.fromMe = YES
        
        self.sendMessage(msg)
		
		if (self.noChatsView == nil || self.noChatsView.superview != nil) {
			self.noChatsView.removeFromSuperview()
		}
    }
    
}