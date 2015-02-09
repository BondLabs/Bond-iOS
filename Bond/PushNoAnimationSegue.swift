//
//  PushNoAnimationSegue.swift
//  Bond
//
//  Created by Bryce Dougherty on 2/8/15.
//  Copyright (c) 2015 Kevin Zhang. All rights reserved.
//

import UIKit

class PushNoAnimationSegue: UIStoryboardSegue {


	override func perform() {
		let sourceViewController = self.sourceViewController as UIViewController
		sourceViewController.navigationController?.pushViewController(self.destinationViewController as UIViewController, animated: false)

	}

}
