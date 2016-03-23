//
//  AdjustView.h
//  Noir
//
//  Created by mac on 10-7-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
#import "Accelerater.h"


#define inside_slider_default_value   0.0
#define outside_slider_default_value  0.0
#define contrast_slider_default_valut 2.0


@class AdjustView;
@protocol AdjustViewDelegate <NSObject>
@optional
-(void)adjustViewReturnExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast isFinal:(BOOL)isFinal;
@end


@interface AdjustView : UIView <CustomPickerDelegate> {

	
	CustomPickerView *_expInsidePicker;
	CustomPickerView *_expOutsidePicker;
	CustomPickerView *_expContrastPicker;
	
	float _expInside;
	float _expOutside;
	float _contrast;
	
	UIImageView *maskView;
}

@property (nonatomic, weak) id<AdjustViewDelegate> delegate;


#pragma mark -
#pragma mark out use functions
-(void)setAdjustByExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast;


#pragma mark -
#pragma mark in use functions
-(void)addAdjusts;
-(void)returnAdjustValueToDelegate:(BOOL)isFinal;

-(void)rotateForAccerateXY:(AccelerXYState)xyState;

@end
