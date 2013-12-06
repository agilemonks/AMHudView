//
//  AMHudView.h
//  AMHudView
//
//  Created by Mark Lilback on 12/4/13.
//  Copyright (c) 2013 Agile Monks, LLC. All rights reserved.
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

#import <UIKit/UIKit.h>

@interface AMHudView : UIView

+(instancetype)HudVisibleInView:(UIView*)view;

@property (nonatomic, copy) NSString *mainLabelText;
@property (nonatomic, strong) UIColor *cancelColor; //tintColor for cancel button
@property (nonatomic) CGFloat progressValue; //0 to 1.0
@property (nonatomic, copy) void (^cancelBlock)(AMHudView*);
@property (nonatomic, getter = isProgressDeterminate) BOOL progressDeterminate;

//convience initializer
-(instancetype)initWithLabelText:(NSString*)text;
+(instancetype)hudWithLabelText:(NSString*)text;

-(void)showOverView:(UIView*)view;
-(void)hide;
@end
