//
//  ControlPadView.h
//  Noir
//
//  Created by mac on 10-7-6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresetsView.h"
#import "TintsView.h"
#import "AdjustView.h"

#import "Accelerater.h"

@class ControlPadView;
@protocol ControlPadViewDelegate <NSObject>
@optional

-(void)presetsChooseIndex:(NSInteger)index data:(id)data; //return the presets choose
-(void)tintsChooseIndex:(NSInteger)index data:(id)data;   //return the tints choose
-(void)adjustExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast isFinal:(BOOL)isFinal;  //return the adjusts
-(void)presetsResetToDefault;
-(void)overWritePresetToIndex:(NSInteger)index;

@end


@interface ControlPadView : UIView <PresetsViewDelegate, TintsViewDelegate, AdjustViewDelegate, UIAlertViewDelegate> {

	PresetsView *_prestsView;
	TintsView *_tintsView;
	AdjustView *_adjustView;
}

@property (nonatomic, weak) id<ControlPadViewDelegate> delegate;



#pragma mark -
#pragma mark in use functions
-(void)setResetBtnForPresets; //set the "reset" button for presets
-(void)resetAction:(id)sender;
-(void)alertYouAction:(NSString*)title withMsg:(NSString*)alertMsg withOK:(NSString*)okMsg withCancel:(NSString*)cancelMsg;



#pragma mark -
#pragma mark out use functions
-(void)setPresetsForItems:(NSArray*)items;
-(void)setTintsForItems:(NSArray*)items;
-(void)setAdjustsForExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast;
-(void)rotatePresetShowViewForTransform:(CGAffineTransform)transfm;

-(void)choosePresetsBtnForIndex:(NSInteger)index bNeedReturn:(BOOL)bReturn;
-(void)chooseTintsBtnForIndex:(NSInteger)index bNeedReturn:(BOOL)bReturn;

-(void)rotateForAccerateXY:(AccelerXYState)xyState;


@end
