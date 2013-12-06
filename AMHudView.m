//
//  AMHudView.m
//  AMHudView
//
//  Created by Mark Lilback on 12/4/13.
//  Copyright (c) 2013 Agile Monks. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "AMHudView.h"

const SInt32 kHorizBuffer = 20;
const SInt32 kVertBuffer = 8;

@interface AMHudBlockingView : UIView
@end

@interface AMHudView ()
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *blockingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@end

@implementation AMHudView

+(instancetype)HudVisibleInView:(UIView*)view
{
	__block AMHudView *theView;
	[view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[AMHudView class]]) {
			theView = obj;
			*stop = YES;
		}
	}];
	return theView;
}

+(BOOL)requiresConstraintBasedLayout { return YES; }

-(instancetype)init
{
	if ((self = [super initWithFrame:CGRectMake(0, 0, 400, 300)])) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
		self.mainLabel.textColor = [UIColor whiteColor];
		[self addSubview:self.mainLabel];
		self.alpha = 0;
		self.backgroundColor = [UIColor blackColor];
		self.layer.cornerRadius = 10.0;
		self.cancelColor = [UIColor whiteColor];
	}
	return self;
}


-(void)updateConstraints
{
	[self removeConstraints:self.constraints];
	NSDictionary *viewsDict;
	UIView *theProgView = self.progressDeterminate ? self.progressBar : self.activityIndicator;
	theProgView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:theProgView];
	if (self.cancelBlock) {
		self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
		self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
		[self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		self.cancelButton.tintColor = self.cancelColor;
		self.cancelButton.frame = CGRectMake(0, 0, 100, [UIFont buttonFontSize]);
		[self addSubview:self.cancelButton];
		[self.cancelButton sizeToFit];
		[self.cancelButton addTarget:self action:@selector(cancelOperation:) forControlEvents:UIControlEventTouchUpInside];
		viewsDict = @{@"mainLabel":self.mainLabel, @"cancelButton":self.cancelButton, @"progress":theProgView};
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton]-|" options:0 metrics:nil views:viewsDict]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progress]-[cancelButton]" options:0 metrics:nil views:viewsDict]];
	} else {
		viewsDict = @{@"mainLabel":self.mainLabel, @"progress":theProgView};
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progress]-|" options:0 metrics:nil views:viewsDict]];
	}
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[mainLabel]" options:0 metrics:nil views:viewsDict]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.mainLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:theProgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mainLabel]-[progress]" options:0 metrics:nil views:viewsDict]];
	
	if (self.progressDeterminate) {
		[self addConstraint:[NSLayoutConstraint constraintWithItem:theProgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:theProgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	}
	
	self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:400];
	[self addConstraint:self.widthConstraint];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

	[super updateConstraints];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	self.widthConstraint.constant = MAX(self.mainLabel.bounds.size.width+60, 100);
	[super layoutSubviews];
}
-(void)showOverView:(UIView *)view
{
	if (self.progressDeterminate) {
		self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		self.progressBar.progressTintColor = [UIColor whiteColor];
		self.progressBar.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
	} else {
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self.activityIndicator startAnimating];
	}
	self.blockingView = [[AMHudBlockingView alloc] initWithFrame:view.bounds];
	self.mainLabel.text = self.mainLabelText;
	[self.mainLabel sizeToFit];
	self.cancelButton.enabled = self.cancelBlock != nil;
	
	[UIView animateWithDuration:0.3 animations:^{
		self.alpha = 1.0;
	}];
	[view addSubview:self.blockingView];
	[view addSubview:self];
}

-(void)hide
{
	[UIView animateWithDuration:0.3 animations:^{
		self.alpha = 0;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
	[self.blockingView removeFromSuperview];
}

-(IBAction)cancelOperation:(id)sender
{
	if (self.cancelBlock)
		self.cancelBlock(self);
}

-(void)setProgressValue:(CGFloat)progressValue
{
	if (progressValue > 1.0)
		progressValue = 1.0;
	if (progressValue < 0)
		progressValue = 0;
	BOOL updateGUI = fabs(progressValue - self.progressBar.progress) > 0.01;
	_progressValue = progressValue;
	if (updateGUI)
		self.progressBar.progress = progressValue;
}

@end

@implementation AMHudBlockingView

-(BOOL)canBecomeFirstResponder { return YES; }

@end