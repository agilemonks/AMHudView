//
//  AMViewController.m
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

#import "AMViewController.h"
#import "AMHudView.h"

@interface AMViewController ()

@end

@implementation AMViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)hideHud:(NSTimer*)timer
{
	AMHudView *hud = timer.userInfo;
	[hud hide];
}

-(IBAction)showBasic:(id)sender
{
	AMHudView *hud = [[AMHudView alloc] init];
	hud.mainLabelText = @"Reconnecting…";
	[hud showOverView:self.view];
	[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideHud:) userInfo:hud repeats:NO];
}

-(IBAction)showBasicCancelable:(id)sender
{
	AMHudView *hud = [[AMHudView alloc] init];
	hud.mainLabelText = @"Reconnecting…";
	hud.cancelColor = [UIColor redColor];
	hud.cancelBlock = ^(AMHudView *bhud) {
		[bhud hide];
	};
	[hud showOverView:self.view];
}

-(IBAction)showDeterminite:(id)sender
{
	AMHudView *hud = [[AMHudView alloc] init];
	hud.mainLabelText = @"Uploading file…";
	hud.progressDeterminate = YES;
	__block float progvalue=0;
	dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
	dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5, 1.0);
	dispatch_source_set_event_handler(timer, ^{
		progvalue += 0.1;
		hud.progressValue = progvalue;
		if (progvalue >= 1.0) {
			dispatch_source_cancel(timer);
			[hud hide];
		}
	});
	[hud showOverView:self.view];
	dispatch_resume(timer);
}

-(IBAction)showCancelableDeterminite:(id)sender
{
	AMHudView *hud = [[AMHudView alloc] init];
	hud.mainLabelText = @"Uploading file…";
	hud.progressDeterminate = YES;
	__block float progvalue=0;
	dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
	dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5, 1.0);
	dispatch_source_set_event_handler(timer, ^{
		progvalue += 0.1;
		hud.progressValue = progvalue;
		if (progvalue >= 1.0) {
			dispatch_source_cancel(timer);
			[hud hide];
		}
	});
	hud.cancelBlock = ^(AMHudView *hview) {
		dispatch_source_cancel(timer);
		[hview hide];
	};
	[hud showOverView:self.view];
	dispatch_resume(timer);
}

@end
