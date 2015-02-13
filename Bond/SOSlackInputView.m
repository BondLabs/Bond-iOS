//
//  SOSlackInputView.m
//  Bond
//
//  Created by Bryce Dougherty on 2/13/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

#import "SOSlackInputView.h"

@interface SOSlackInputView()
{
	CGRect keyboardFrame;
	UIViewAnimationCurve keyboardCurve;
	double keyboardDuration;
	UIView *inputAccessoryForFindingKeyboard;
	CGFloat initialInputViewPosYWhenKeyboardIsShown;
	BOOL keyboardHidesFromDragging;
	UITapGestureRecognizer *tapGesture;
	UIPanGestureRecognizer *panGesture;
}

@property (weak, nonatomic) UIView *keyboardView;
@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIView *tintView;

@end


@implementation SOSlackInputView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
	self = [super init];
	if (self) {
		[self setupInitialData];
		[self setup];
	}
	return self;
}


- (void)setupInitialData
{
	self.textInitialHeight = 40.0f;
	self.textMaxHeight = 130.0f;
	self.textleftMargin = 5.0f;
	self.textTopMargin = 5.5f;
	self.textBottomMargin = 5.5f;

	CGRect frame = CGRectZero;
	frame.size.height = self.textInitialHeight;
	frame.size.width = [UIScreen mainScreen].bounds.size.width;
	self.frame = frame;

	self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}

- (void)setup
{
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	self.tintView = [[UIView alloc] initWithFrame:self.frame];
	self.tintView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(164/255.0) blue:(255/255.0) alpha:0.5];
	self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	self.blurView.frame = self.bounds;
	[self.blurView.contentView addSubview:self.tintView];
	[self addSubview:self.blurView];

		//self.textView = [[SOPlaceholderedTextView alloc] init];
	/*
	self.textView = [[SLKTextView alloc] init];
	self.textView.textColor = [UIColor whiteColor];
	self.textView.font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
	self.textView.delegate = self;
	self.textView.backgroundColor = [UIColor clearColor];
	self.textView.textContainer.lineFragmentPadding = 0;
	self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//self.textView.placeholderText = NSLocalizedString(@"Type message...", nil);
	inputAccessoryForFindingKeyboard = [[UIView alloc] initWithFrame:CGRectZero];
	self.textView.inputAccessoryView = inputAccessoryForFindingKeyboard;
	[self adjustTextViewSize];
	[self addSubview:self.textView];

	self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	self.sendButton.backgroundColor = [UIColor colorWithRed:0 green:164/255.0 blue:1.0 alpha:0.75];
	[self.sendButton setTitleColor:[UIColor colorWithRed:0.0 green:65.0/255.0 blue:136.0/255.0 alpha:1.0]
						  forState:UIControlStateHighlighted];
	self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
	[self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
	self.sendButton.frame = CGRectMake(0, 0, 70, self.textInitialHeight);
	[self.sendButton addTarget:self action:@selector(sendTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.sendButton];
*/

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNote:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNote:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrientationDidChandeNote:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

	[self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
	self.sendButton.frame = CGRectMake(0, 0, 70, self.textInitialHeight);

	[self adjustInputView];
}

@end
