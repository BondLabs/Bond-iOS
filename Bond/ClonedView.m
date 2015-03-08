//
//  ClonedView.m
//  Bond
//
//  Created by Bryce Dougherty on 3/7/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

#import "ClonedView.h"

@implementation ClonedView

@synthesize srcView;

- (id)initWithView:(UIView *)src {
	self = [super initWithFrame:src.frame];
	if (self) {
		srcView = src;
	}
	return self;
}

+ (UIImage *)captureView:(UIView *)view withArea:(CGRect)screenRect {

	UIGraphicsBeginImageContext(screenRect.size);

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);

	[view.layer renderInContext:ctx];

	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return newImage;
}

- (void)drawRect:(CGRect)rect
{
	[srcView.layer renderInContext:UIGraphicsGetCurrentContext()];
}


@end
