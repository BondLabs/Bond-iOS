//
//  FadeSegue.m
//  Bond
//
//  Created by Bryce Dougherty on 2/28/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

#import "FadeSegue.h"

@implementation FadeSegue

- (void) perform
{
	CATransition* transition = [CATransition animation];

	transition.duration = 0.3;
	transition.type = kCATransitionFade;

	[[self.sourceViewController navigationController].view.layer addAnimation:transition forKey:kCATransition];
	[[self.sourceViewController navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
