//
//  PresetsView.h
//  Noir
//
//  Created by mac on 10-7-5.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PresetsView;
@protocol PresetsViewDelegate <NSObject>
@optional
-(void)presetsButtonChooseIndex:(NSInteger)index data:(id)data; //return index & data for choose
-(void)overWritePresetByIndex:(NSInteger)index;
@end


@interface PresetsView : UIView <UIAlertViewDelegate> {

	NSArray *_buttons;
	NSArray *_items;
	float _btnWidth;
	float _btnHeight;

	NSTimer *_timer;
	NSInteger _touchDownIndex;
	NSArray *_showViews;

	UIAlertView *mAlert;

}

@property (nonatomic, weak) id<PresetsViewDelegate> delegate;
@property (nonatomic, retain) NSTimer *_timer;
@property (nonatomic, retain) UIAlertView *mAlert;



#pragma mark -
#pragma mark out use function @overwrite system function
//the item is NSDictionary type, the key-value pair include: "data"->data, "image"->image, "image_sel"->image selected
//if set height=0 use default height as frame.height, if set width=0 use width=height
- (id)initWithFrame:(CGRect)frame items:(NSArray*)items dele:(id)dele btnWidth:(float)width btnHeight:(float)height;




#pragma mark -
#pragma mark in/out use functions
-(void)setButtonsForItems:(NSArray*)items; //additional using this function if there are no items when useing "initWithFrame" function, the paramater "items" is just like the "initWithFrame"
-(void)chooseButtonForIndex:(NSInteger)index bReturnToDelegate:(BOOL)bReturnTodele; //each time only a button has disable state
-(void)setBackGroundWithImage:(UIImage*)bgImage orColor:(UIColor*)bgColor; //first Priority is image, if image==nil use color, if color==nil use default clearColor
-(void)rotateShowViewForTransform:(CGAffineTransform)transfm;


#pragma mark -
#pragma mark in use functions
-(void)itemAction:(id)sender;
-(void)btnTouchDown:(id)sender;
-(float)blankWidthBetweenBtns;
-(void)alertYouAction:(NSString*)title withMsg:(NSString*)alertMsg withOK:(NSString*)okMsg withCancel:(NSString*)cancelMsg;



#pragma mark -
#pragma mark timer functions
-(void)startTimer;
-(void)stopTimer;
-(void)FireTheTimerMethod;
-(void)timerFireMethod:(NSTimer*)theTimer;



@end
