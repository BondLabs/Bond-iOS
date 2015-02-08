//
//  SOMessageInputView.m
//  SOMessaging
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE



void bondLog(id x) {

	NSLog(@"%@", x);


}



#import "SOMessageInputView.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationController+Rotation.h"

@interface SOMessageInputView() <UITextViewDelegate, UIGestureRecognizerDelegate>
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

@end

@implementation SOMessageInputView

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
		//self.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(193/255.0) blue:(255/255.0) alpha:0.2];


	UIBlurEffect *blurEffect;

	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];


	UIView *colorView = [[UIView alloc] initWithFrame:self.frame];
	colorView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(164/255.0) blue:(255/255.0) alpha:0.5];

	UIVisualEffectView *visualEffectView;
	visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];



	visualEffectView.frame = self.bounds;
		//visualEffectView.tintColor = [UIColor colorWithRed:(0/255.0) green:(193/255.0) blue:(255/255.0) alpha:1.0];
	[visualEffectView.contentView addSubview:colorView];


	[self addSubview:visualEffectView];
    
    self.textView = [[SOPlaceholderedTextView alloc] init];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    [self.sendButton addTarget:self action:@selector(sendTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];



    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNote:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNote:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrientationDidChandeNote:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    self.textView.placeholderText = NSLocalizedString(@"Type message...", nil);
    [self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    self.sendButton.frame = CGRectMake(0, 0, 70, self.textInitialHeight);
    
    [self adjustInputView];
}

#pragma mark - Public methods
- (void)adjustInputView
{
    CGRect frame = self.frame;
    frame.size.height = self.textInitialHeight;
    self.frame = frame;
    
    CGRect sendFrame = self.sendButton.frame;
    sendFrame.origin = CGPointMake(self.frame.size.width - sendFrame.size.width, 0);
    self.sendButton.frame = sendFrame;
    self.sendButton.center = CGPointMake(self.sendButton.center.x, self.textInitialHeight/2);
    
    CGRect txtBgFrame;
    txtBgFrame.origin = CGPointMake(0, 0);
    txtBgFrame.size = CGSizeMake(self.frame.size.width, self.textInitialHeight);
    
    CGRect txtFrame = self.frame;
    txtFrame.origin.x = txtBgFrame.origin.x;
    txtFrame.origin.y = txtBgFrame.origin.y;
    txtFrame.size.width = txtBgFrame.size.width - 70;
    txtFrame.size.height = txtBgFrame.size.height;
    self.textView.frame = txtFrame;
    
    [self adjustPosition];
}

- (void)adjustPosition
{
    CGRect frame = self.frame;
    frame.origin.y = self.superview.bounds.size.height - frame.size.height;
    self.frame = frame;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, self.frame.size.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    if (tapGesture) {
        [self removeGestureRecognizer:tapGesture];
    }
    
    if (panGesture) {
        [self.superview removeGestureRecognizer:panGesture];
    }
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    panGesture.delegate = self;
    
    [self addGestureRecognizer:tapGesture];
    [self.superview addGestureRecognizer:panGesture];
    
    UINavigationController *nc = [self navigationControllerInstance];
    nc.cantAutorotate = NO;
}

- (void)adjustTableViewWithCurve:(BOOL)withCurve scrollsToBottom:(BOOL)scrollToBottom
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, keyboardFrame.size.height + self.frame.size.height, 0.0);
    
    NSInteger section = [(id<UITableViewDataSource>)self.delegate numberOfSectionsInTableView:self.tableView] - 1;
     if (section == -1) {
     	self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        return;
    }
    
    NSInteger row = [(id<UITableViewDataSource>)self.delegate tableView:self.tableView numberOfRowsInSection:section] - 1;
    
    if (row >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationDuration:keyboardDuration];
        if (withCurve) {
            [UIView setAnimationCurve:keyboardCurve];
        }
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        if (scrollToBottom) {
            if (row >= 0) {
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        [UIView commitAnimations];
    } else {
    	self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }
}

#pragma mark - Actions
- (void)sendTapped:(id)sender
{
    NSString *msg = self.textView.text;
    self.textView.text = @"";
    [self adjustTextViewSize];
	
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageInputView:didSendMessage:)]) {
        [self.delegate messageInputView:self didSendMessage:msg];
    }
}

#pragma mark - private Methods
- (void)adjustTextViewSize
{
    CGRect usedFrame = [self.textView.layoutManager usedRectForTextContainer:self.textView.textContainer];
    
    CGRect frame = self.textView.frame;
    CGFloat delta = ceilf(usedFrame.size.height) - frame.size.height;
    
    CGFloat lineHeight = self.textView.font.lineHeight;
    int numberOfActualLines = ceilf(self.frame.size.height / lineHeight);
    
	CGFloat actualHeight = [self.textView.text sizeWithFont:self.textView.font constrainedToSize:self.frame.size].height;//numberOfActualLines * lineHeight;
    
		delta = actualHeight - self.textView.font.lineHeight - 5;
    CGRect frm = self.frame;
    frm.size.height += ceilf(delta);
    frm.origin.y -= ceilf(delta);
    
    if (frm.size.height < self.textMaxHeight) {
        if (frm.size.height < self.textInitialHeight) {
            frm.size.height = self.textInitialHeight;
            frm.origin.y = self.superview.bounds.size.height - frm.size.height - keyboardFrame.size.height;
        }

        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frm;

        } completion:^(BOOL finished) {
            [self scrollToCaretInTextView:self.textView animated:NO];
        }];
    } else {
        [self scrollToCaretInTextView:self.textView animated:NO];
    }
    
    [self adjustTableViewWithCurve:NO scrollsToBottom:YES];
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
		//[self adjustTextViewSize];


	CGRect frame = textView.frame;
	frame.size.height = textView.contentSize.height;
	CGSize size = CGSizeMake(self.frame.size.width - 8 - 8, 100000);



	size.height = [textView.text sizeWithFont:textView.font constrainedToSize:size].height + 8 + 8;
	CGRect origRect = self.frame;
	[UIView animateWithDuration:0.1 animations:^ {
	self.frame = CGRectMake(self.frame.origin.x,(origRect.origin.y + origRect.size.height) - MAX(size.height, 40), self.frame.size.width,  MAX(size.height, 40));
	}];

	bondLog([NSString stringWithFormat:@"The origin is %@", NSStringFromCGRect(self.frame)]);
	bondLog([NSString stringWithFormat:@"The new origin is %@", NSStringFromCGSize(size)]);







}





#pragma mark - Notifications handlers
- (void)handleKeyboardWillShowNote:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect windowRect = self.window.bounds;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardRect = CGRectMake(keyboardRect.origin.x, keyboardRect.origin.y, MAX(keyboardRect.size.width,keyboardRect.size.height), MIN(keyboardRect.size.width,keyboardRect.size.height));
        windowRect = CGRectMake(windowRect.origin.x, windowRect.origin.y, MAX(windowRect.size.width,windowRect.size.height), MIN(windowRect.size.width,windowRect.size.height));
    }
    
    keyboardFrame = keyboardRect;
    
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    keyboardCurve = curve;
    
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardDuration = duration;
    
    CGRect frame = self.frame;
    // calculate the absolute ending point (based on the window rather than superview, which could be contained in a tab bar or tool bar)
    frame.origin.y = windowRect.size.height - frame.size.height - keyboardRect.size.height;
    initialInputViewPosYWhenKeyboardIsShown = frame.origin.y;
    
    [self adjustTableViewWithCurve:YES scrollsToBottom:YES];
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        self.frame = frame;
    }];
    
    //Closing keyboard on tap
    UITapGestureRecognizer *tapGestureForTableView = [[UITapGestureRecognizer alloc] initWithTarget:self.textView action:@selector(resignFirstResponder)];
    [self.tableView addGestureRecognizer:tapGestureForTableView];
}

- (void)handleKeyboardWillHideNote:(NSNotification *)notification
{
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardCurve = curve;
    keyboardDuration = duration;
    
    CGRect frame = self.frame;
    frame.origin.y = self.superview.bounds.size.height - frame.size.height;
    keyboardFrame = CGRectZero;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        self.frame = frame;
    } completion:^(BOOL finished) {

    }];
    
    [self adjustTableViewWithCurve:YES scrollsToBottom:!keyboardHidesFromDragging];
    
    keyboardHidesFromDragging = NO;
}

- (void)handleOrientationDidChandeNote:(NSNotification *)note
{
    [self performSelector:@selector(adjustTextViewSize) withObject:nil afterDelay:0.1];
}

#pragma mark - Gestures
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (![self.textView isFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    static CGPoint panStartPos;
    if (pan.state == UIGestureRecognizerStateBegan) {
        panStartPos = [pan locationInView:self.superview];
    }
    
    // if keyboard isn't opened then return.
    if (![self.textView isFirstResponder]) {
        return;
    }
    
    static BOOL panDidEnterIntoThisView = NO;
    static BOOL panDidStartetFromThisView = NO;
    static CGFloat initialPosY          = 0;
    static CGFloat kbInitialPosY        = 0;
    
    if (!self.keyboardView) {
        self.keyboardView = inputAccessoryForFindingKeyboard.superview;
    }
    
    CGRect frame   = self.frame;
    CGRect kbFrame = self.keyboardView.frame;
    
    CGPoint point = [pan locationInView:self.superview];

    if (!panDidEnterIntoThisView) {
        if (CGRectContainsPoint(self.frame, point)) {
            panDidEnterIntoThisView = YES;
            _viewIsDragging = YES;
            UINavigationController *nc = [self navigationControllerInstance];
            nc.cantAutorotate = YES;
            initialPosY = self.frame.origin.y;
            kbInitialPosY = self.keyboardView.frame.origin.y;
            [pan setTranslation:CGPointZero inView:pan.view];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(self.frame, panStartPos)) {
            panDidStartetFromThisView = YES;
        } else {
            panDidStartetFromThisView = NO;
        }
    }
    
    if (_viewIsDragging)
    {
        CGPoint translation = [pan translationInView:self.superview];
        
        frame.origin.y   += translation.y;
        kbFrame.origin.y += translation.y;
        
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
        {
            UINavigationController *nc = [self navigationControllerInstance];
            nc.cantAutorotate = NO;

            panDidEnterIntoThisView = NO;
            panDidStartetFromThisView = NO;
            _viewIsDragging = NO;
            
            CGPoint vel = [pan velocityInView:pan.view];

         /* if (frame.origin.y < initialPosY + (self.frame.size.height + self.keyboardView.frame.size.height)/2 && NO) { */
            if (vel.y < 0) { // if scroll direction is up , then fully open keyboard
                frame.origin.y   = initialPosY;
                kbFrame.origin.y = kbInitialPosY;
                
                [UIView animateWithDuration:keyboardDuration animations:^{
                    self.frame = frame;
                    self.keyboardView.frame = kbFrame;
                }];
                
            } else { // else , if scroll direction is down , then close keyboard
                
                frame.origin.y   = self.superview.frame.size.height - self.frame.size.height;
                kbFrame.origin.y = self.superview.frame.size.height;
                
                [UIView animateWithDuration:keyboardDuration animations:^{
                    self.frame = frame;
                    self.keyboardView.frame = kbFrame;
                } completion:^(BOOL finished) {
                    keyboardHidesFromDragging = YES;
                    [self hideKeeyboardWithoutAnimation];
                }];
                kbFrame.size.height = 0;
            }

            UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbFrame.size.height + self.frame.size.height, 0.0);
            [UIView beginAnimations:@"animKb" context:NULL];
            [UIView setAnimationDuration:keyboardDuration];

            self.tableView.contentInset = contentInsets;
            self.tableView.scrollIndicatorInsets = contentInsets;

            [UIView commitAnimations];
            
            return;
        }
        
        if (frame.origin.y < initialPosY) {
            
            UINavigationController *nc = [self navigationControllerInstance];
            nc.cantAutorotate = NO;
            
            panDidEnterIntoThisView = NO;
            _viewIsDragging = NO;
            
            frame.origin.y   = initialPosY;
            kbFrame.origin.y = kbInitialPosY;
            
            [UIView animateWithDuration:keyboardDuration animations:^{
                self.frame = frame;
                self.keyboardView.frame = kbFrame;
            }];
            
        } else if (frame.origin.y > self.superview.frame.size.height - self.frame.size.height) {
            
            UINavigationController *nc = [self navigationControllerInstance];
            nc.cantAutorotate = NO;
            
            panDidEnterIntoThisView = NO;
            _viewIsDragging = NO;
            
            frame.origin.y   = self.superview.frame.size.height - self.frame.size.height;
            kbFrame.origin.y = self.superview.frame.size.height;
            
            [UIView animateWithDuration:keyboardDuration animations:^{
                self.frame = frame;
                self.keyboardView.frame = kbFrame;
            } completion:^(BOOL finished) {
                keyboardHidesFromDragging = YES;
                [self hideKeeyboardWithoutAnimation];
                
                // Canceling pan gesture
                pan.enabled = NO;
                pan.enabled = YES;
            }];
            
        } else {
            
            self.frame = frame;
            self.keyboardView.frame = kbFrame;
            
            if (panDidStartetFromThisView) {
                UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, keyboardFrame.size.height - (kbFrame.origin.y - keyboardFrame.origin.y) + self.frame.size.height, 0.0);
                
                self.tableView.contentInset = contentInsets;
                self.tableView.scrollIndicatorInsets = contentInsets;
            }
        }
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)closeKeyboard
{
    CGRect frame = self.keyboardView.frame;
    CGRect selfFrame = self.frame;
    frame.origin.y = self.superview.frame.size.height;
    selfFrame.origin.y = frame.origin.y - selfFrame.size.height;

    __weak SOMessageInputView *weakSelf = self;
    [UIView animateWithDuration:keyboardDuration animations:^{
        weakSelf.keyboardView.frame = frame;
        weakSelf.frame = selfFrame;
    } completion:^(BOOL finished) {
        [self hideKeeyboardWithoutAnimation];
    }];
}

- (void)hideKeeyboardWithoutAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [self.textView resignFirstResponder];
    
    [UIView commitAnimations];
}

#pragma mark - 
- (UINavigationController*)navigationControllerInstance
{
    UINavigationController *resultNVC = nil;
    UIViewController *vc = nil;
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            vc = (UIViewController*)nextResponder;
            break;
        }
    }
    
    if (vc)
    {
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            resultNVC = (UINavigationController *)vc;
        }
        else
        {
            resultNVC = vc.navigationController;
        }
    }
    
    return resultNVC;
}

#pragma mark - Gestures delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
