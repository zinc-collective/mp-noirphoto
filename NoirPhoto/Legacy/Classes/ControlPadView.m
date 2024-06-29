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
		if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			imageName = @"ctrl_pad_bg-iPad.png";
		}

		self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		self.bgView.image = [UIImage imageNamed:imageName];
		[self addSubview:self.bgView];

    }
    return self;
}




#pragma mark -
#pragma mark in use functions
-(void)setResetBtnForPresets
{
    // this is never called.  It's here for posterity when the app gets rebuilt (next year?)
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
    __weak ControlPadView *weakSelf = self;
    UIAlertAction* okAction = [[UIAlertAction class] actionWithTitle:okMsg style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        if (weakSelf != nil && weakSelf.delegate != nil) {
            [weakSelf.delegate presetsResetToDefault];
        }
    }];
    UIAlertAction* cancelAction = [[UIAlertAction class] actionWithTitle:cancelMsg style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alert = [[UIAlertController class] alertControllerWithTitle:title message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    if(self.delegate) {
        [self.delegate presentPresetsViewAlert:alert];
    }
}






#pragma mark -
#pragma mark in use functions
-(void)setPresetsForItems:(NSArray*)items
{
    if(items == nil || [items count] == 0) return;
    
    if(self.prestsView == nil)
    {
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            self.prestsView = [[PresetsView alloc] initWithFrame:presets_rect_iPad items:nil dele:self btnWidth:80.0 btnHeight:80.0];
        }
        else
        {
            self.prestsView = [[PresetsView alloc] initWithFrame:presets_rect2 items:nil dele:self btnWidth:42.0 btnHeight:32.0];
        }
        
        [self addSubview:self.prestsView];
    }
    
    [self.prestsView setButtonsForItems:items];
    
}
-(void)setTintsForItems:(NSArray*)items
{
    if(items == nil || [items count] == 0) return;
    
    if(self.tintsView == nil)
    {
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            self.tintsView = [[TintsView alloc] initWithFrame:tints_rect_iPad items:nil dele:self posformat:pfLine btnWidth:85 btnHeight:85];
        }
        else
        {
            self.tintsView = [[TintsView alloc] initWithFrame:tints_rect items:nil dele:self posformat:pfMartix btnWidth:50.0 btnHeight:50.0];
        }
        
        [self addSubview:self.tintsView];
    }
    
    [self.tintsView setButtonsForItems:items];
}
-(void)setAdjustsForExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast
{
    if(self.adjustView == nil)
    {
        CGRect adjustFrame = adjusts_rect;
        if(UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            adjustFrame = adjusts_rect_iPad;
        }
        
        self.adjustView = [[AdjustView alloc] initWithFrame:adjustFrame];
        [self.adjustView setDelegate:self];
        [self addSubview:self.adjustView];
    }
    
    [self.adjustView setAdjustByExpinside:expInside expOutside:expOutside contrast:contrast];
}
-(void)rotatePresetShowViewForTransform:(CGAffineTransform)transfm
{
    if(self.prestsView == nil) return;
    [self.prestsView rotateShowViewForTransform:transfm];
}

-(void)choosePresetsBtnForIndex:(NSInteger)index bNeedReturn:(BOOL)bReturn
{
    if(self.prestsView == nil) return;
    [self.prestsView chooseButtonForIndex:index bReturnToDelegate:bReturn];
}
-(void)chooseTintsBtnForIndex:(NSInteger)index bNeedReturn:(BOOL)bReturn
{
    if(self.tintsView == nil) return;
    [self.tintsView chooseButtonForIndex:index bReturnToDelegate:bReturn];
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
-(void)presentPresetsViewAlert:(UIAlertController *)alert
{
    if(self.delegate) {
        [self.delegate presentPresetsViewAlert:alert];
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



@end
