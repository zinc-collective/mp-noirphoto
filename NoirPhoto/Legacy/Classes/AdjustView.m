//
//  AdjustView.m
//  Noir
//
//  Created by mac on 10-7-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AdjustView.h"



@implementation AdjustView

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		self.backgroundColor = [UIColor clearColor];
		
		//add adjusts
		[self addAdjusts];
		
		//add adjust mask view
		NSString *maskName = @"adjust_mask.png";
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			maskName = @"adjust_mask-iPad.png";
		}
		
		maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		maskView.image = [UIImage imageNamed:maskName];
		maskView.userInteractionEnabled = NO;
		[self addSubview:maskView];
		//[maskView release];
		
    }
    return self;
}






#pragma mark -
#pragma mark in use functions
-(void)addAdjusts
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //ipad
	{
		//add outside picker
		_expOutsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(1.0, 0.0, 66.0, 183.0) image:[UIImage imageNamed:@"adjust_in_out-iPad.png"] topOffset:44 btmOffset:38.0];
		[_expOutsidePicker setParameters:-4.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		_expOutsidePicker.defaultValue = 0.0;
		_expOutsidePicker.delegate = self;
		[self addSubview:_expOutsidePicker];
		
		
		//add inside picker
		_expInsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(77.0, 0.0, 66.0, 183.0) image:[UIImage imageNamed:@"adjust_in_out-iPad.png"] topOffset:44 btmOffset:38.0];
		[_expInsidePicker setParameters:-4.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		_expInsidePicker.defaultValue = 0.0;
		_expInsidePicker.delegate = self;
		[self addSubview:_expInsidePicker];
		
		
		//add contrast picker
		_expContrastPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(153.0, 0.0, 66.0, 183.0) image:[UIImage imageNamed:@"adjust_contrast-iPad.png"] topOffset:44 btmOffset:38.0];
		[_expContrastPicker setParameters:1.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		_expContrastPicker.defaultValue = 2.0;
		_expContrastPicker.delegate = self;
		[self addSubview:_expContrastPicker];
	}
	else //iphone
	{
		//add outside picker
		_expOutsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(1.0, 0.0, 49.0, 152.0) image:[UIImage imageNamed:@"adjust_in_out.png"] topOffset:40.5 btmOffset:36.0];
		[_expOutsidePicker setParameters:-4.0 maxValue:4.0 useHeight:219.0 useOffset:76.0];
		_expOutsidePicker.defaultValue = 0.0;
		_expOutsidePicker.delegate = self;
		[self addSubview:_expOutsidePicker];
		
		
		//add inside picker
		_expInsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(57.0, 0.0, 49.0, 152.0) image:[UIImage imageNamed:@"adjust_in_out.png"] topOffset:40.5 btmOffset:36.0];
		[_expInsidePicker setParameters:-4.0 maxValue:4.0 useHeight:219 useOffset:76.0];
		_expInsidePicker.defaultValue = 0.0;
		_expInsidePicker.delegate = self;
		[self addSubview:_expInsidePicker];
		
		
		//add contrast picker
		_expContrastPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(113.0, 0.0, 49.0, 152.0) image:[UIImage imageNamed:@"adjust_contrast.png"] topOffset:40.5 btmOffset:36.0];
		[_expContrastPicker setParameters:1.0 maxValue:4.0 useHeight:219.0 useOffset:76.0];
		_expContrastPicker.defaultValue = 2.0;
		_expContrastPicker.delegate = self;
		[self addSubview:_expContrastPicker];
	}
}

-(void)returnAdjustValueToDelegate:(BOOL)isFinal
{
//	NSLog(@"_expInside  :%f", _expInside);
//	NSLog(@"_expOutside :%f", _expOutside);
//	NSLog(@"_contrast   :%f", _contrast);
	
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(adjustViewReturnExpinside:expOutside:contrast:isFinal:)])
	{
		[self.delegate adjustViewReturnExpinside:_expInside expOutside:_expOutside contrast:_contrast isFinal:isFinal];
	}
}





#pragma mark -
#pragma mark out use functions
-(void)setAdjustByExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast
{
	_expInside = expInside;
	_expOutside = expOutside;
	_contrast = contrast;

		
	//init the slider bar position
	[_expInsidePicker setTheCurrentValue:expInside];
	[_expOutsidePicker setTheCurrentValue:expOutside];
	[_expContrastPicker setTheCurrentValue:contrast];
	
}


- (void)rotateForAccerateXY:(AccelerXYState)xyState
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIImage *adjustInOutImage = nil;
		UIImage *adjustContrastImage = nil;
		
		if (xyState == accelerXYStatePortrait ) {
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out-iPad.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast-iPad.png"];
		} else if ( xyState == accelerXYStatePortraitUpsideDown){ 
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out-iPad.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast-iPad.png"];
		} else if (xyState == accelerXYStateLandscapeLeft) {
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out-iPad4.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast-iPad4.png"];
		} else {
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out-iPad2.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast-iPad2.png"];
		}

		
		//add outside picker
		UIView *old = _expOutsidePicker;
		_expOutsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(1.0, 0.0, 66.0, 183.0) image:adjustInOutImage topOffset:44 btmOffset:38.0];
		[_expOutsidePicker setParameters:-4.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		_expOutsidePicker.defaultValue = 0.0;
		_expOutsidePicker.delegate = self;
		[self addSubview:_expOutsidePicker];
		
		_expOutsidePicker.alpha = 0;
		[UIView beginAnimations:@"remove old" context:(__bridge void * _Nullable)(old)];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_expOutsidePicker.alpha = 1.0;
		old.alpha = 0.0;
		[UIView commitAnimations];
		
		
		//add inside picker
		UIView *old2 = _expInsidePicker;
		_expInsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(77.0, 0.0, 66.0, 183.0) image:adjustInOutImage topOffset:44 btmOffset:38.0];
		[_expInsidePicker setParameters:-4.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		_expInsidePicker.defaultValue = 0.0;
		_expInsidePicker.delegate = self;
		[self addSubview:_expInsidePicker];
		
		_expInsidePicker.alpha = 0;
		[UIView beginAnimations:@"remove old" context:(__bridge void * _Nullable)(old2)];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_expInsidePicker.alpha = 1.0;
		old2.alpha = 0.0;
		[UIView commitAnimations];
		
		
		//add contrast picker
		UIView *old3 = _expContrastPicker;
		_expContrastPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(153.0, 0.0, 66.0, 183.0) image:adjustContrastImage topOffset:44 btmOffset:38.0];
		[_expContrastPicker setParameters:1.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		_expContrastPicker.defaultValue = 2.0;
		_expContrastPicker.delegate = self;
		[self addSubview:_expContrastPicker];
		
		_expContrastPicker.alpha = 0;
		[UIView beginAnimations:@"remove old" context:(__bridge void * _Nullable)(old3)];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_expContrastPicker.alpha = 1.0;
		old3.alpha = 0.0;
		[UIView commitAnimations];
		
		

	} else { //iphone
		UIImage *adjustInOutImage = nil;
		UIImage *adjustContrastImage = nil;
		if (xyState == accelerXYStatePortrait) {
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast.png"];
		} else if (xyState == accelerXYStatePortraitUpsideDown) {
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast.png"];
		} else if(xyState == accelerXYStateLandscapeLeft) {
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out4.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast4.png"];
		} else { //iphone right
			adjustInOutImage = [UIImage imageNamed:@"adjust_in_out2.png"];
			adjustContrastImage = [UIImage imageNamed:@"adjust_contrast2.png"];
			
			
		}
		
		//add outside picker
		UIView *old = _expOutsidePicker;
		_expOutsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(1.0, 0.0, 49.0, 152.0) image: adjustInOutImage topOffset:40.5 btmOffset:36.0];
		[_expOutsidePicker setParameters:-4.0 maxValue:4.0 useHeight:219.0 useOffset:76.0];
		_expOutsidePicker.defaultValue = 0.0;
		_expOutsidePicker.delegate = self;
		[self addSubview:_expOutsidePicker];
		
		_expOutsidePicker.alpha = 0;
		[UIView beginAnimations:@"remove old" context:(__bridge void * _Nullable)(old)];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_expOutsidePicker.alpha = 1.0;
		old.alpha = 0.0;
		[UIView commitAnimations];
		
		
		//add inside picker
		UIView *old2 = _expInsidePicker;
		_expInsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(57.0, 0.0, 49.0, 152.0) image:adjustInOutImage topOffset:40.5 btmOffset:36.0];
		[_expInsidePicker setParameters:-4.0 maxValue:4.0 useHeight:219 useOffset:76.0];
		_expInsidePicker.defaultValue = 0.0;
		_expInsidePicker.delegate = self;
		[self addSubview:_expInsidePicker];
		
		_expInsidePicker.alpha = 0;
		[UIView beginAnimations:@"remove old" context:(__bridge void * _Nullable)(old2)];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_expInsidePicker.alpha = 1.0;
		old2.alpha = 0.0;
		[UIView commitAnimations];
		
		
		//add contrast picker
		UIView *old3 = _expContrastPicker;
		_expContrastPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(113.0, 0.0, 49.0, 152.0) image:adjustContrastImage topOffset:40.5 btmOffset:36.0];
		[_expContrastPicker setParameters:1.0 maxValue:4.0 useHeight:219.0 useOffset:76.0];
		_expContrastPicker.defaultValue = 2.0;
		_expContrastPicker.delegate = self;
		[self addSubview:_expContrastPicker];
		
		_expContrastPicker.alpha = 0;
		[UIView beginAnimations:@"remove old" context:(__bridge void * _Nullable)(old3)];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_expContrastPicker.alpha = 1.0;
		old3.alpha = 0.0;
		[UIView commitAnimations];
		
		

	}

	[maskView removeFromSuperview];
	[self addSubview:maskView];

	
	[_expInsidePicker setTheCurrentValue2:_expInside];
	[_expOutsidePicker setTheCurrentValue2:_expOutside];
	[_expContrastPicker setTheCurrentValue2:_contrast];
	
}


- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if(finished ){
		if([animationID isEqualToString:@"remove old"])
		{
			UIView *v = (__bridge UIView *)(context);
			if([v superview]){
				[v removeFromSuperview];
			}
		}
	}
}

#pragma mark -
#pragma mark delegate functions
//CustomPickerDelegate
-(void)currentValueFromCustomPicker:(CustomPickerView*)customPicker value:(float)value isFinal:(BOOL)bFinalValue
{
	if(customPicker == _expInsidePicker)
	{
		_expInside = value;
	}
	else if(customPicker == _expOutsidePicker)
	{
		_expOutside = value;
	}
	else if(customPicker == _expContrastPicker)
	{
		_contrast = value; 
	}
	
	[self returnAdjustValueToDelegate:bFinalValue];
}



@end