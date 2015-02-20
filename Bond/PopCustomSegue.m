	//
	//  PopCustomSegue.m
	//  Pop Custom Segue
	//
	//  Created by PJ Vea on 5/13/14.
	//  Copyright (c) 2014 Vea Software. All rights reserved.
	//

#import "PopCustomSegue.h"
#import <POP/POP.h>

@implementation PopCustomSegue

-(void)perform {

	UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
	UIViewController *destinationController = (UIViewController*)[self destinationViewController];

	CALayer *layer = destinationController.view.layer;
	[layer pop_removeAllAnimations];

	POPSpringAnimation *xAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
	POPSpringAnimation *sizeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];

	xAnim.fromValue = @(320);
	xAnim.springBounciness = 16;
	xAnim.springSpeed = 10;

	sizeAnim.fromValue = [NSValue valueWithCGSize:CGSizeMake(64, 114)];

	xAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
		NSLog(@"Working");
	};

	[layer pop_addAnimation:xAnim forKey:@"position"];
	[layer pop_addAnimation:sizeAnim forKey:@"size"];

	[sourceViewController.navigationController pushViewController:destinationController animated:NO];
}

@end
