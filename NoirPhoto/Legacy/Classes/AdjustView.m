//
//  AdjustView.m
//  Noir
//
//  Created by mac on 10-7-14.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
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
		if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			maskName = @"adjust_mask-iPad.png";
		}

        self.adjustMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.adjustMaskView.image = [UIImage imageNamed:maskName];
        self.adjustMaskView.userInteractionEnabled = NO;
		[self addSubview:self.adjustMaskView];

    }
    return self;
}






#pragma mark -
#pragma mark in use functions
-(void)addAdjusts
{
	if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) //ipad
	{
		//add outside picker
		self.expOutsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(1.0, 0.0, 66.0, 183.0) image:[UIImage imageNamed:@"adjust_in_out-iPad.png"] topOffset:44 btmOffset:38.0];
		[self.expOutsidePicker setParameters:-4.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		self.expOutsidePicker.defaultValue = 0.0;
		self.expOutsidePicker.delegate = self;
		[self addSubview:self.expOutsidePicker];


		//add inside picker
		self.expInsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(77.0, 0.0, 66.0, 183.0) image:[UIImage imageNamed:@"adjust_in_out-iPad.png"] topOffset:44 btmOffset:38.0];
		[self.expInsidePicker setParameters:-4.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		self.expInsidePicker.defaultValue = 0.0;
		self.expInsidePicker.delegate = self;
		[self addSubview:self.expInsidePicker];


		//add contrast picker
		self.expContrastPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(153.0, 0.0, 66.0, 183.0) image:[UIImage imageNamed:@"adjust_contrast-iPad.png"] topOffset:44 btmOffset:38.0];
		[self.expContrastPicker setParameters:1.0 maxValue:4.0 useHeight:294.0 useOffset:91.5];
		self.expContrastPicker.defaultValue = 2.0;
		self.expContrastPicker.delegate = self;
		[self addSubview:self.expContrastPicker];
	}
	else //iphone
	{
		//add outside picker
		self.expOutsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(1.0, 0.0, 49.0, 152.0) image:[UIImage imageNamed:@"adjust_in_out.png"] topOffset:40.5 btmOffset:36.0];
		[self.expOutsidePicker setParameters:-4.0 maxValue:4.0 useHeight:219.0 useOffset:76.0];
		self.expOutsidePicker.defaultValue = 0.0;
		self.expOutsidePicker.delegate = self;
		[self addSubview:self.expOutsidePicker];


		//add inside picker
		self.expInsidePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(57.0, 0.0, 49.0, 152.0) image:[UIImage imageNamed:@"adjust_in_out.png"] topOffset:40.5 btmOffset:36.0];
		[self.expInsidePicker setParameters:-4.0 maxValue:4.0 useHeight:219 useOffset:76.0];
		self.expInsidePicker.defaultValue = 0.0;
		self.expInsidePicker.delegate = self;
		[self addSubview:self.expInsidePicker];


		//add contrast picker
		self.expContrastPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(113.0, 0.0, 49.0, 152.0) image:[UIImage imageNamed:@"adjust_contrast.png"] topOffset:40.5 btmOffset:36.0];
		[self.expContrastPicker setParameters:1.0 maxValue:4.0 useHeight:219.0 useOffset:76.0];
		self.expContrastPicker.defaultValue = 2.0;
		self.expContrastPicker.delegate = self;
		[self addSubview:self.expContrastPicker];
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
	[self.expInsidePicker setTheCurrentValue:expInside];
	[self.expOutsidePicker setTheCurrentValue:expOutside];
	[self.expContrastPicker setTheCurrentValue:contrast];

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
	if(customPicker == self.expInsidePicker)
	{
		_expInside = value;
	}
	else if(customPicker == self.expOutsidePicker)
	{
		_expOutside = value;
	}
	else if(customPicker == self.expContrastPicker)
	{
		_contrast = value;
	}

	[self returnAdjustValueToDelegate:bFinalValue];
}



@end
