//
//  BondBond.swift
//  Bond
//
//  Created by Bryce Dougherty on 2/28/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

import UIKit

class BondBond: NSObject {

	var name: String!
	var traits: String!
	var userID: String!

	class func getTraitsFromString(traits: String) -> NSArray {


		let traitsArray = NSMutableArray()

		if traits != "" {

			for i in 0...(countElements(traits) - 1) {

				if Array(traits)[i] == "1" {
					traitsArray.addObject(AppData.data.activityNames[i])
				}
			}


		}

		return traitsArray
		
	}
   
}
