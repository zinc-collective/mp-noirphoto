//
//  CustomPickerView.h
//  Noir
//
//  Created by mac on 10-12-6.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RScrollView.h"


@class CustomPickerView;
@protocol CustomPickerDelegate <NSObject>
@optional
-(void)currentValueFromCustomPicker:(CustomPickerView*)customPicker value:(float)value isFinal:(BOOL)bFinalValue;
@end


@interface CustomPickerView : UIView <UIScrollViewDelegate, RScrollViewDelegate> {

	RScrollView *_scrollView;

	float _minValue;
	float _maxValue;
	float _useHeight;
	float _useOffset;

	BOOL _bOutSet;

	float defaultValue;
}

@property (nonatomic, weak) id<CustomPickerDelegate> delegate;
@property (nonatomic) float defaultValue;

#pragma mark -
#pragma mark rewrite the system functions
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image topOffset:(float)topOffset btmOffset:(float)btmOffset; //the image could not be nil, the frame.size must be equal the image.size


#pragma mark -
#pragma mark out use functions
-(void)setParameters:(float)minValue maxValue:(float)maxValue useHeight:(float)useHeight useOffset:(float)useOffset;
-(void)setTheCurrentValue:(float)value;

-(void)setTheCurrentValue2:(float)value;

#pragma mark -
#pragma mark in use functions
-(void)pickTheCurrentValue:(BOOL)bFinalPick;



@end
