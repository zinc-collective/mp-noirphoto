//
//  ControlPadView.m
//  Noir
//
//  Created by mac on 10-7-6.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import "ControlPadView.h"



#define reset_btn_rect		CGRectMake(280.0, 20.0, 30.0, 30.0)
#define presets_rect		CGRectMake(25.0, 5.0, 270.0, 32.0)
#define presets_rect2		CGRectMake(10.0, 5.0, 270.0, 32.0)
#define tints_rect			CGRectMake(202.0, 65.0, 103.0, 103.0)
#define adjusts_rect		CGRectMake(24.0, 67.5, 164.0, 153.0)

//#define reset_btn_rect_iPad		CGRectMake(280.0, 20.0, 30.0, 30.0)
#define presets_rect_iPad		CGRectMake(267.0, 43.0, 488.0, 80.0)
#define tints_rect_iPad			CGRectMake(270.0, 157.0, 368.0, 85.0)
#define adjusts_rect_iPad		CGRectMake(26.0, 53, 224.0, 183.0)



@implementation ControlPadView
@synthesize delegate;


#pragma mark -
#pragma mark system functions
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code

		self.backgroundColor = [UIColor clearColor];

		//add background view
		NSString *imageName = @"ctrl_pad_bg.png";
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			imageName = @"ctrl_pad_bg-iPad.png";
		}

		UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		bgView.image = [UIImage imageNamed:imageName];
		[self addSubview:bgView];

    }
    return self;
}




#pragma mark -
#pragma mark in use functions
-(void)setResetBtnForPresets
{
	UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	resetBtn.frame = reset_btn_rect;
	[resetBtn setImage:[UIImage imageNamed:@"reset_btn.png"] forState:UIControlStateNormal];
	[resetBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:resetBtn];
}
-(void)resetAction:(id)sender
{
	[self alertYouAction:NSLocalizedString(@"control pad reset alert title", nil)
				 withMsg:NSLocalizedString(@"control pad reset alert message", nil)
				  withOK:NSLocalizedString(@"control pad reset alert OK", nil)
			  withCancel:NSLocalizedString(@"control pad reset alert Cancel", nil)];
}
-(void)alertYouAction:(NSString*)title withMsg:(NSString*)alertMsg withOK:(NSString*)okMsg withCancel:(NSString*)cancelMsg
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:alertMsg delegate:self cancelButtonTitle:okMsg otherButtonTitles:cancelMsg, nil];
	[alert setDelegate:self];
	alert.message = alertMsg;
	[alert show];
}






#pragma mark -
#pragma mark in use functions
-(void)setPresetsForItems:(NSArray*)items
{
	if(items == nil || [items count] == 0) return;

	if(_prestsView == nil)
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			_prestsView = [[PresetsView alloc] initWithFrame:presets_rect_iPad items:nil dele:self btnWidth:80.0 btnHeight:80.0];
		}
		else
		{
			_prestsView = [[PresetsView alloc] initWithFrame:presets_rect2 items:nil dele:self btnWidth:42.0 btnHeight:32.0];
		}

		[self addSubview:_prestsView];
	}

	[_prestsView setButtonsForItems:items];

}
-(void)setTintsForItems:(NSArray*)items
{
	if(items == nil || [items count] == 0) return;

	if(_tintsView == nil)
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			_tintsView = [[TintsView alloc] initWithFrame:tints_rect_iPad items:nil dele:self posformat:pfLine btnWidth:85 btnHeight:85];
		}
		else
		{
			_tintsView = [[TintsView alloc] initWithFrame:tints_rect items:nil dele:self posformat:pfMartix btnWidth:50.0 btnHeight:50.0];
		}

		[self addSubview:_tintsView];
	}

	[_tintsView setButtonsForItems:items];
}
-(void)setAdjustsForExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast
{
	if(_adjustView == nil)
	{
		CGRect adjustFrame = adjusts_rect;
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			adjustFrame = adjusts_rect_iPad;
		}

		_adjustView = [[AdjustView alloc] initWithFrame:adjustFrame];
		[_adjustView setDelegate:self];
		[self addSubview:_adjustView];
	}

	[_adjustView setAdjustByExpinside:expInside expOutside:expOutside contrast:contrast];
}
-(void)rotatePresetShowViewForTransform:(CGAffineTransform)transfm
{
	if(_prestsView == nil) return;
	[_prestsView rotateShowViewForTransform:transfm];
}

-(void)choosePresetsBtnForIndex:(NSInteger)index bNeedReturn:(BOOL)bReturn
{
	if(_prestsView == nil) return;
	[_prestsView chooseButtonForIndex:index bReturnToDelegate:bReturn];
}
-(void)chooseTintsBtnForIndex:(NSInteger)index bNeedReturn:(BOOL)bReturn
{
	if(_tintsView == nil) return;
	[_tintsView chooseButtonForIndex:index bReturnToDelegate:bReturn];
}



#pragma mark -
#pragma mark delegate functions
//PresetsViewDelegate
-(void)presetsButtonChooseIndex:(NSInteger)index data:(id)data
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(presetsChooseIndex:data:)])
	{
		[self.delegate presetsChooseIndex:index data:data];
	}
}
-(void)overWritePresetByIndex:(NSInteger)index
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(overWritePresetToIndex:)])
	{
		[self.delegate overWritePresetToIndex:index];
	}
}

//TintsViewDelegate
-(void)tintsButtonChooseIndex:(NSInteger)index data:(id)data
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(tintsChooseIndex:data:)])
	{
		[self.delegate tintsChooseIndex:index data:data];
	}
}

//AdjustViewDelegate
-(void)adjustViewReturnExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast isFinal:(BOOL)isFinal
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(adjustExpinside:expOutside:contrast:isFinal:)])
	{
		[self.delegate adjustExpinside:expInside expOutside:expOutside contrast:contrast isFinal:isFinal];
	}
}

//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(presetsResetToDefault)])
		{
			[self.delegate presetsResetToDefault];
		}
	}
}



@end
