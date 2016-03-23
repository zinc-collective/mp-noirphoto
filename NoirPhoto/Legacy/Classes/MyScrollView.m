//
//  MyScrollView.m
//  UIImageViewTest
//
//  Created by baiwei on 6/13/11.
//  Copyright 2011 cfca. All rights reserved.
//

#import "MyScrollView.h"
#import "NoirAppDelegate.h"
#import "NoirViewController.h"

@implementation MyScrollView
- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan: touches withEvent:event]; 
    }
    [super touchesBegan: touches withEvent: event];
	
	UITouch *touch = [touches anyObject];
	NSInteger tapCount = [touch tapCount];
	if (tapCount == 2) {
		NSLog(@"2 tap");
		NoirAppDelegate *appDelegate = (NoirAppDelegate*)[[UIApplication sharedApplication]delegate];
		NoirViewController *viewController = appDelegate.viewController;
		[viewController.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
		
		[viewController._vignetteView showVignetteView:YES];

		
	}
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded: touches withEvent:event]; 
    }
    [super touchesEnded: touches withEvent: event];
}
@end
