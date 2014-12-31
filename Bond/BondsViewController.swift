//
//  BondsViewController.swift
//  Bond
//
//  Created by Kevin Zhang on 12/30/14.
//  Copyright (c) 2014 Kevin Zhang. All rights reserved.
//

import UIKit

class BondsViewController: UITableViewController {

    var bonds:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get bonds from online
        bonds = ["Kevin Zhang", "Daniel Singer", "Jason Fieldman"]
        
        // Customize view and navigation bar
        self.view.backgroundColor = self.UIColorFromRGB(0x5A5A5A)
        self.tableView.separatorColor = UIColor.blackColor()
        self.tableView.allowsSelection = false
        self.navigationItem.title = "Bonds"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = self.UIColorFromRGB(0x2D2D2D)
        
        // Set row height
        self.tableView.rowHeight = 60.0
    }

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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Remove seperator inset
        cell.separatorInset = UIEdgeInsetsZero
        
        // Prevent the cell from inheriting the Table View's margin settings
        cell.preservesSuperviewLayoutMargins = false
        
        // Explictly set your cell's layout margins
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
