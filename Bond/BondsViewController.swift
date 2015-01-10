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
    var bonds:[String]!
    
    /* * *
     * * * Do basic setup
     * * */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get bonds from online
        bonds = ["Kevin Zhang", "Daniel Singer", "Jason Fieldman"]
        
        // Customize view and navigation bar
        self.view.backgroundColor = AppData.util.UIColorFromRGB(0x5A5A5A)
        self.tableView.separatorColor = UIColor.blackColor()
        self.navigationItem.title = "Bonds"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = AppData.util.UIColorFromRGB(0x2D2D2D)
        
        // Set row height
        self.tableView.rowHeight = 60.0
        
        // Set tabbar image for controller
		/*var barHeight:CGFloat! = (self.tabBarController?.tabBar.frame.height)!
		println(barHeight)
        var bondIcon = UIImage(named: "Bonds(i).png")!
        var finalBG:UIImage
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.width / 2, barHeight), true, 0.0)
        AppData.util.UIColorFromRGB(0x2D2D2D).setFill()
        UIRectFill(CGRect(origin: CGPointZero, size: CGSizeMake(self.view.frame.width / 2, barHeight)))
        bondIcon.drawInRect(CGRectMake(self.view.frame.width / 6 + 10, 10, self.view.frame.width / 6 - 20, self.view.frame.width / 6 - 20))
        finalBG = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
		println(finalBG.size.height)
        self.tabBarItem = UITabBarItem(title: nil, image: finalBG, selectedImage: finalBG)
		self.tabBarItem.setTitlePositionAdjustment(UIOffsetZero)
		self.tabBarItem.imageInsets = UIEdgeInsetsZero*/
    }

    /* * *
     * * * Function necessary for tableview
     * * */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonds.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BondTableCell", forIndexPath: indexPath) as BondTableCell

        cell.setup(bonds[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            bonds.removeAtIndex(indexPath.row)
        }
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
            (segue.destinationViewController as BondsDetailViewController).id = 3 // Set id of bond here
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
