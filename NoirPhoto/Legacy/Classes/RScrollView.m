//
//  RScrollView.m
//  Noir
//
//  Created by mac on 11-1-7.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import "RScrollView.h"


@implementation RScrollView
@synthesize rdelegate;


#pragma mark -
#pragma mark touches functions
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSSet *allTouches = [event allTouches];
	if([allTouches count] == 1)
	{
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		if(touch.tapCount == 2)
		{
			//双点击
			if(self.rdelegate &&[(NSObject*)self.rdelegate respondsToSelector:@selector(rScrollViewDidDoubleClick)])
			{
				[self.rdelegate rScrollViewDidDoubleClick];
			}
		}
	}
}



@end
