//
//  CustomPickerView.m
//  Noir
//
//  Created by mac on 10-12-6.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import "CustomPickerView.h"


@implementation CustomPickerView
@synthesize delegate;
@synthesize defaultValue;


#pragma mark -
#pragma mark rewrite the system functions
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image topOffset:(float)topOffset btmOffset:(float)btmOffset
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.

		_bOutSet = NO;

		//init _scrollView
		_scrollView = [[RScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		_scrollView.backgroundColor = [UIColor clearColor];
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
		_scrollView.delegate = self;
		_scrollView.rdelegate = self;

		//add image
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, topOffset, image.size.width, image.size.height)];
		imageView.image = image;
		[_scrollView addSubview:imageView];

		_scrollView.contentSize = CGSizeMake(frame.size.width, image.size.height + topOffset + btmOffset);
		[self addSubview:_scrollView];

    }
    return self;
}





#pragma mark -
#pragma mark out use functions
-(void)setParameters:(float)minValue maxValue:(float)maxValue useHeight:(float)useHeight useOffset:(float)useOffset
{
	_minValue = minValue;
	_maxValue = maxValue;
	_useHeight = useHeight;
	_useOffset = useOffset;
}
-(void)setTheCurrentValue:(float)value
{
	_bOutSet = YES;

	float visibleHeight = _scrollView.frame.size.height;
	CGPoint contentOffset = _scrollView.contentOffset;
	float totalHeight = _useHeight;

	float curUseValue = value - _minValue;
	float curPresent = curUseValue/(_maxValue - _minValue);
	float perUseHeight = totalHeight * curPresent;

	float offsetY = perUseHeight + _useOffset - visibleHeight/2;


	//move to new offset Y
	[UIView beginAnimations:@"movement" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3f];

	contentOffset.y = offsetY;
	_scrollView.contentOffset = contentOffset;

	[UIView commitAnimations];

}

-(void)setTheCurrentValue2:(float)value
{
	_bOutSet = YES;

	float visibleHeight = _scrollView.frame.size.height;
	CGPoint contentOffset = _scrollView.contentOffset;
	float totalHeight = _useHeight;

	float curUseValue = value - _minValue;
	float curPresent = curUseValue/(_maxValue - _minValue);
	float perUseHeight = totalHeight * curPresent;

	float offsetY = perUseHeight + _useOffset - visibleHeight/2;


	//move to new offset Y
	[UIView beginAnimations:@"movement" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0];

	contentOffset.y = offsetY;
	_scrollView.contentOffset = contentOffset;

	[UIView commitAnimations];

}



#pragma mark -
#pragma mark in use functions
-(void)pickTheCurrentValue:(BOOL)bFinalPick
{
	float visibleHeight = _scrollView.frame.size.height;
	CGPoint contentOffset = _scrollView.contentOffset;
	float totalHeight = _useHeight;

	float perUseHeight = visibleHeight/2 + contentOffset.y - _useOffset;
	float curPersent = perUseHeight/totalHeight;


	float curValue;

	if(curPersent >= 1.0)
	{
		curValue = _maxValue;
	}
	else if(curPersent <= 0.0)
	{
		curValue = _minValue;
	}
	else
	{
		float curUseValue = (_maxValue - _minValue) * curPersent;
		curValue = _minValue + curUseValue;
	}

	NSLog(@"curValue : %f", curValue);

	//return to delegate
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(currentValueFromCustomPicker:value:isFinal:)])
	{
		[self.delegate currentValueFromCustomPicker:self value:curValue isFinal:bFinalPick];
	}
}





#pragma mark -
#pragma mark delegate functions
//UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(_bOutSet)
	{
		_bOutSet = NO;
		return;
	}

	[self pickTheCurrentValue:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//NSLog(@"scrollViewDidEndDecelerating");
	[self pickTheCurrentValue:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	//NSLog(@"scrollViewDidEndDragging: %d", decelerate);
	if(!decelerate)
	{
		[self pickTheCurrentValue:YES];
	}
}

//RScrollViewDelegate
-(void)rScrollViewDidDoubleClick
{
	[self setTheCurrentValue:self.defaultValue];

	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(currentValueFromCustomPicker:value:isFinal:)])
	{
		[self.delegate currentValueFromCustomPicker:self value:self.defaultValue isFinal:YES];
	}
}





@end
