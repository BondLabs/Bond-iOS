//
//  SOSlackInputView.h
//  Bond
//
//  Created by Bryce Dougherty on 2/13/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

#import "SLKTextInputbar.h"
#import "SOPlaceholderedTextView.h"
#import "SOMessagingDelegate.h"
#import "SOMessageTextView.h"

#define kAutoResizingMaskAll UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth


@interface SOSlackInputView : SLKTextInputbar


@property (weak, nonatomic) UITableView *tableView;

#pragma mark - Properties
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;

@property (strong, nonatomic) UIView *separatorView;

@property (nonatomic, readonly) BOOL viewIsDragging;

/**
 * After setting above properties make sure that you called
 * -adjustInputView method for apply changes
 */
@property (nonatomic) CGFloat textInitialHeight;
@property (nonatomic) CGFloat textMaxHeight;
@property (nonatomic) CGFloat textTopMargin;
@property (nonatomic) CGFloat textBottomMargin;
@property (nonatomic) CGFloat textleftMargin;
@property (nonatomic) CGFloat textRightMargin;
	//--

@property (weak, nonatomic) id<SOMessagingDelegate> delegate;

#pragma mark - Methods
- (void)adjustInputView;
- (void)adjustPosition;

@end
