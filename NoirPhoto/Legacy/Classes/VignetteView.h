//
//  VignetteView.h
//  OrzQuarz
//
//  Created by mac on 10-11-30.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parameter.h"



typedef enum{
	actionNone,
	actionReset,
	actionPan,
	actionDrag,
	actionScall,
	actionScallAnyWhere
} ActionType;



@class VignetteView;
@protocol VignetteDelegate <NSObject>
@optional
-(void)vignetteViewDidChange:(Parameter*)parameter isFinal:(BOOL)isFinal bChangePresetState:(BOOL)bChange;
@end



@interface VignetteView : UIView {


	CGMutablePathRef	_ellipsePath;
	CGMutablePathRef	_pointPath0;
	CGMutablePathRef	_pointPath1;
	CGMutablePathRef	_pointPath2;
	CGMutablePathRef	_pointPath3;

	CGRect				_ellipseRect;


	double				_ellipseA;
	double				_ellipseB;
	double				_ellipseAngle;
	CGPoint				_ellipseCenter;

	double				_ellipseA_default;
	double				_ellipseB_default;
	double				_ellipseAngle_default;
	CGPoint				_ellipseCenter_default;

	CGRect				_photoRect;

	CGPoint				_point0; //the 0,1,2,3 -> left, top, right, bottom
	CGPoint				_point1;
	CGPoint				_point2;
	CGPoint				_point3;

	CGRect				_ptCheckBox0;
	CGRect				_ptCheckBox1;
	CGRect				_ptCheckBox2;
	CGRect				_ptCheckBox3;

	BOOL				_bInPtBox0;
	BOOL				_bInPtBox1;
	BOOL				_bInPtBox2;
	BOOL				_bInPtBox3;


	ActionType			_actionType;
	CGPoint             _panTouchBeginPoint;

	CGPoint				_scallAnyBeginPoint1;
	CGPoint				_scallAnyBeginPoint2;
	//double				_scallAnyBeginAngle;

	float				_offsetX;
	float				_offsetY;

	NSTimer				*_timer;
	UIColor				*_vignetteColor;


	double				_scallAnyAngleTemp;
	float				_scallAnyKLenthTemp;
}

@property (nonatomic, weak) id<VignetteDelegate> delegate;
@property (nonatomic, retain) NSTimer *_timer;
@property (nonatomic, retain) UIColor *_vignetteColor;


#pragma mark -
#pragma mark in use functions
-(void)resetEllipseParams;
-(void)updateEllipseParams;
-(void)DrawEllipse;
-(void)drawVignette;
-(void)checkStateForPoint:(CGPoint)touchPoint;
-(BOOL)checkIfInEllipse:(CGPoint)touchPoint;
-(ActionType)actionTypeForTouchs:(NSArray*)touchs; //这个必须保证已经判断完毕四个顶点的选中状态
-(CGPoint)transformPoint:(CGPoint)fromPoint;
-(void)calculateEllipseParamsForDragActionByPoint:(CGPoint)touchPoint;
-(void)setVignettePramsForOffsetX:(float)offsetX offsetY:(float)offsetY;
-(void)setVignetteParamsForPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;
-(void)returnVignetteAction:(BOOL)isFinal bChangePresetState:(BOOL)bChange;
-(void)showVignetteView:(BOOL)bShow;

-(void)vignetteViewDidHide;




#pragma mark -
#pragma mark out use functions
-(void)setVignetteForParam:(Parameter*)parameter photoRect:(CGRect)photoRect;
-(Parameter*)paramsForVignette;



#pragma mark -
#pragma mark timer functions
-(void)startTimer;
-(void)stopTimer;
-(void)FireTheTimerMethod;
-(void)timerFireMethod:(NSTimer*)theTimer;




@end
