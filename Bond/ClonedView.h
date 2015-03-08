//
//  ClonedView.h
//  Bond
//
//  Created by Bryce Dougherty on 3/7/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClonedView : UIView
@property(nonatomic, weak) UIView *srcView;
- (id)initWithView:(UIView *)src;
+ (UIImage *)captureView:(UIView *)view withArea:(CGRect)screenRect;
@end