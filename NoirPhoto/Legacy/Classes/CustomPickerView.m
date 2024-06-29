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
        
        _topOffset = topOffset;
        _btmOffset = btmOffset;
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
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, topOffset, image.size.width, image.size.height)];
        _imageView.image = image;
		[_scrollView addSubview:_imageView];

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
// all of this needs to be dynamic.   need a function to pass in new frame after autolayout is complete.  Is there an onLayoutChange callback I can use instead of a public function?
	float visibleHeight = _scrollView.frame.size.height;
    NSLog(@"## - setTheCurrentValue: %.2f", visibleHeight);
    CGFloat duration = 0.3f;
	float totalHeight = _useHeight;

	float curUseValue = value - _minValue;
	float curPresent = curUseValue/(_maxValue - _minValue);
	float perUseHeight = totalHeight * curPresent;

	float offsetY = perUseHeight + _useOffset - visibleHeight/2;


	//move to new offset Y
    [[UIView class] animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGPoint contentOffset = self->_scrollView.contentOffset;
        contentOffset.y = offsetY;
        self->_scrollView.contentOffset = contentOffset;
    } completion:nil];
}

-(void)setTheCurrentValue2:(float)value
{
	_bOutSet = YES;

	float visibleHeight = _scrollView.frame.size.height;
    CGFloat duration = 0.0f;
	float totalHeight = _useHeight;

	float curUseValue = value - _minValue;
	float curPresent = curUseValue/(_maxValue - _minValue);
	float perUseHeight = totalHeight * curPresent;

	float offsetY = perUseHeight + _useOffset - visibleHeight/2;


	//move to new offset Y
    [[UIView class] animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGPoint contentOffset = self->_scrollView.contentOffset;
        contentOffset.y = offsetY;
        self->_scrollView.contentOffset = contentOffset;
    } completion:nil];
}

-(void)setLayoutContraintsForScrollView
{
    if (_scrollView != nil && _imageView != nil) {
        float _originaScrolllHeight = _scrollView.frame.size.height;
        CGSize _originaImageFrame = _imageView.frame.size;
        float _originalImaageRatio = _originaImageFrame.height / _originaImageFrame.width;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        

      NSArray<NSLayoutConstraint *> *constraints = @[
        [_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
        [_imageView.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:_originalImaageRatio]
      ];
      // Need to scale the image proportionally and set the constraint above
      [NSLayoutConstraint activateConstraints:constraints];
      [self layoutIfNeeded];
        float _scaledTopOffset = (_topOffset * _scrollView.frame.size.height) / _originaScrolllHeight;
        float _scaledBtmOffset = (_btmOffset * _scrollView.frame.size.height) / _originaScrolllHeight;
        // 47.8..., 41.3...
        // from topOffset:44 btmOffset:38.0
        NSLog(@"## - _scaledTopOffset: %.2f -- _scaledBtmOffset: %.2f", _scaledTopOffset, _scaledBtmOffset);
      _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, (_imageView.frame.size.height + _scaledTopOffset + _scaledBtmOffset));
    }
    
    //add image
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, topOffset, image.size.width, image.size.height)];
    
    
        
    // I need to do something with the contentView and ImageView to make sure the values match the scroll position as expected.
    /*
         this is a clue: _scrollView.contentSize = CGSizeMake(frame.size.width, image.size.height + topOffset + btmOffset);
    */
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
