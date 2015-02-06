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
    var partnerImage: UIImage!
    var dataSource: NSMutableArray!
    var tableViewHeaderView: UIView!
    
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
        var nameLabel = UILabel()
        nameLabel.text = "Test"
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
        nameLabel.sizeToFit()
        nameLabel.center = CGPointMake(self.view.frame.width / 2, 45)
        self.view.addSubview(nameLabel)
        
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
    }

    func loadMessages () {
        self.dataSource = ChatContentManager.sharedManager.generateConversation().mutableCopy() as NSMutableArray
    }
    
    override func messages() -> NSMutableArray! {
        return self.dataSource
    }
    
    override func heightForMessageForIndex(index: Int) -> CGFloat {
        var height = super.heightForMessageForIndex(index)
        height += 15
        return height
    }
    
    override func configureMessageCell(cell: SOMessageCell!, forMessageAtIndex index: Int) {
        let message: Message = self.dataSource[index] as Message
        
        if (!message.fromMe) {
            cell.contentInsets = UIEdgeInsetsMake(0, 4.0, 0, 0) //Move content for 4 pt. to right
        } else {
            cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 4.0) //Move content for 4 pt. to left
        }
        cell.backgroundColor = UIColor.purpleColor()
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
        /*let labelTag: NSInteger = 90
        let message: SOMessage = cell.message as SOMessage
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        var label: UILabel? = cell.contentView.viewWithTag(labelTag) as? UILabel
        if (label == nil) {
            label = UILabel()
            label!.font = UIFont.systemFontOfSize(8)
            label!.textColor = UIColor.grayColor()
            label!.tag = labelTag
            cell.contentView.addSubview(label!)
        }
        label!.text = formatter.stringFromDate(message.date)
        label?.sizeToFit()
        
        var frame = label!.frame
        let topMargin: CGFloat = 5.0
        let leftMargin: CGFloat = 15.0
        let rightMargin: CGFloat = 20.0
        
        if (message.fromMe) {
            frame.origin.x = cell.contentView.frame.size.width - cell.userImageView.frame.size.width - frame.size.width - rightMargin;
            frame.origin.y = cell.containerView.frame.origin.y + cell.containerView.frame.size.height + topMargin;
            label!.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        } else {
            frame.origin.x = cell.containerView.frame.origin.x + cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width + leftMargin;
            frame.origin.y = cell.containerView.frame.origin.y + cell.containerView.frame.size.height + topMargin;
            label!.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
        }
        
        label!.frame = frame
        */
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
    
    override func didSelectMedia(media: NSData!, inMessageCell cell: SOMessageCell!) {
        super.didSelectMedia(media, inMessageCell: cell)
    }
    
    override func messageInputView(inputView: SOMessageInputView!, didSendMessage message: String!) {
        if (message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).utf16Count == 0) {
            return
        }
        let msg = Message()
        msg.text = message
        msg.fromMe = YES
        
        self.sendMessage(msg)
    }
    
}