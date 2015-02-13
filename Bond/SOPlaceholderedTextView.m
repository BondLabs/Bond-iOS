//
//  SOPlaceholderedTextView.m
//  SOMessaging
//
//  Created by artur on 4/28/14.
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

#import "SOPlaceholderedTextView.h"

@interface SOPlaceholderedTextView()

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation SOPlaceholderedTextView

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.placeholderTextColor = [UIColor lightGrayColor];
    self.placeholderLabel = [[UILabel alloc] init];
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.hidden = YES;
    
    [self addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    
    [self setNeedsDisplay];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	/*
    UITextView *tv = object;
    
    //Bottom vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = (topCorrect < 0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = -5, .y = -topCorrect};
	 */
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
/*
	if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
		CGRect rect = [self.textContainer.layoutManager usedRectForTextContainer:self.textContainer];
		UIEdgeInsets inset = self.textContainerInset;
		self.contentSize = UIEdgeInsetsInsetRect(rect, inset).size;
	}
*/
		//[self setNeedsDisplay];
}

- (void)textViewTextDidChange:(NSNotification *)note
{

	CGRect rect = [self.textContainer.layoutManager usedRectForTextContainer:self.textContainer];
	UIEdgeInsets inset = self.textContainerInset;
	self.contentSize = UIEdgeInsetsInsetRect(rect, inset).size;

	/*
	CGRect size = self.frame;
	size.size = self.contentSize;
	self.frame = size;
	 */

		//[self setNeedsDisplay];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    if (self.placeholderText.length && !self.text.length) {

        if (!self.font) {
            self.font = [UIFont systemFontOfSize:12];
        }
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.placeholderText attributes:@{NSForegroundColorAttributeName : self.placeholderTextColor, NSFontAttributeName : self.font}];
        
        self.placeholderLabel.attributedText = attrString;
        [self.placeholderLabel sizeToFit];
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}
 */

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
