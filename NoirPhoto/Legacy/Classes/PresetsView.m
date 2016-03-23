//
//  PresetsView.m
//  Noir
//
//  Created by mac on 10-7-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PresetsView.h"
#import "NoirAppDelegate.h"


@implementation PresetsView
@synthesize delegate;
@synthesize _timer;
@synthesize mAlert;


#pragma mark -
#pragma mark out use function @overwrite system function
- (id)initWithFrame:(CGRect)frame items:(NSArray*)items dele:(id)dele btnWidth:(float)width btnHeight:(float)height
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		self.delegate = dele;
		
		//got widht & height
		if(height==0)
		{
			_btnHeight = frame.size.height;
		}
		else
		{
			_btnHeight = height;
		}
		
		if(width==0)
		{
			_btnWidth = _btnHeight;
		}
		else
		{
			_btnWidth = width;
		}

		
		//background
		[self setBackGroundWithImage:nil orColor:nil];
		
		//add buttons
		[self setButtonsForItems:items];
    }
    return self;
}





#pragma mark -
#pragma mark in/out use functions
-(void)setButtonsForItems:(NSArray*)items 
{
    _items = items;
	
	
	//remove old buttons
	if(_buttons != nil && [_buttons count] != 0)
	{
		for(UIButton *button in _buttons)
		{
			if([button superview])
			{
				[button removeFromSuperview];
			}
		}
		
		_buttons = nil;
	}
	
	
	//add buttons
	if(items == nil || [items count] == 0) return;
	
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    NSMutableArray *showViews = [[NSMutableArray alloc] init];
	
	float posX = 0.0;
	float posY = 0.0;
	float blankWidth = [self blankWidthBetweenBtns];
	
	for(int i=0; i<[items count]; i++)
	{
		NSDictionary *itemDic = [items objectAtIndex:i];
		
		
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			//add show view to self
			UIImage *showImage = [itemDic valueForKey:@"image_show"];
			float sw = showImage.size.width;
			float sh = showImage.size.height;
			
            UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(posX+11+6, posY+7+6, sw-12, sh-12)];
			backView.userInteractionEnabled = NO;
			backView.image = [UIImage imageNamed:@"preset_back_iPad.png"];
			[self addSubview:backView];
			
			
            UIImageView *showView = [[UIImageView alloc] initWithFrame:CGRectMake(posX+11+6, posY+7+6, sw-12, sh-12)];
			showView.userInteractionEnabled = NO;
			showView.image = showImage;
			[self addSubview:showView];
			
			//add show views to array
			[showViews addObject:showView];
		}
		
		
		//add button to self
		UIImage *btnImage = [itemDic valueForKey:@"image"];
		//UIImage *btnImageSel = [itemDic valueForKey:@"image_sel"];
		
		UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		itemBtn.frame = CGRectMake(posX, posY, _btnWidth, _btnHeight);
		[itemBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
		//[itemBtn setBackgroundImage:btnImageSel forState:UIControlStateHighlighted];
		itemBtn.tag = i;
		[itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
		[itemBtn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
        itemBtn.exclusiveTouch = YES;
		[self addSubview:itemBtn];
        

		
		//重新计算posX
		posX = posX + _btnWidth + blankWidth;
		
		//add btns into array
		[buttons addObject:itemBtn];
		
	}
	
    _buttons = buttons;
    _showViews = showViews;
	
}
-(void)chooseButtonForIndex:(NSInteger)index bReturnToDelegate:(BOOL)bReturnTodele
{
	if(_buttons == nil || [_buttons count] ==0) return;
	if(_items == nil || [_items count] == 0) return;
	
	/* //这里是要disable选中的按钮，也可以做成换一下图片的
	for(UIButton *btn in _buttons)
	{
		if(!btn.enabled)
		{
			btn.enabled = YES;
		}
		
		if(btn.tag == index)
		{
			btn.enabled = NO;
		}
	}
	*/
	
	//用图片来标志选中状态
	for(UIButton *btn in _buttons)
	{
		NSDictionary *itemDic = [_items objectAtIndex:btn.tag];
		UIImage *btnImage = [itemDic valueForKey:@"image"];
		
		if(btn.tag == index)
		{
			btnImage = [itemDic valueForKey:@"image_sel"];
		}
		
		[btn setBackgroundImage:btnImage forState:UIControlStateNormal];
	}

	
	if(bReturnTodele)
	{
		if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(presetsButtonChooseIndex:data:)])
		{
			NSDictionary *itemDic = [_items objectAtIndex:index];
			if(itemDic == nil) return;
			
			id data = (id)[itemDic valueForKey:@"data"];
			[self.delegate presetsButtonChooseIndex:index data:data];
			
//			NSLog(@"selected preset: %d", index);
		}
	}
}
-(void)setBackGroundWithImage:(UIImage*)bgImage orColor:(UIColor*)bgColor
{
	if(bgImage != nil)
	{
		[self.layer setContents:(id)[bgImage CGImage]];	
	}
	else if(bgColor != nil)
	{
		self.backgroundColor = bgColor;
	}
	else
	{
		self.backgroundColor = [UIColor clearColor];
	}
}
-(void)rotateShowViewForTransform:(CGAffineTransform)transfm
{
	if(_showViews == nil || [_showViews count] == 0) return;
	
	for(UIImageView *showView in _showViews)
	{
		showView.transform = transfm;
	}
}





#pragma mark -
#pragma mark in use functions
-(void)itemAction:(id)sender
{
	[self stopTimer];
	
	UIButton *itemBtn = (UIButton*)sender;
	[self chooseButtonForIndex:itemBtn.tag bReturnToDelegate:YES];
}
-(void)btnTouchDown:(id)sender
{
	UIButton *itemBtn = (UIButton*)sender;
	_touchDownIndex = itemBtn.tag;
	
	[self startTimer];
}
-(float)blankWidthBetweenBtns
{
	float frameWidth = self.frame.size.width;
	NSInteger count = [_items count];
	
	if(count <= 1) return 0.0;
	
	float blankWidth = (frameWidth - _btnWidth*count)/(count-1);
	return blankWidth;
}
-(void)alertYouAction:(NSString*)title withMsg:(NSString*)alertMsg withOK:(NSString*)okMsg withCancel:(NSString*)cancelMsg
{
	if(self.mAlert == nil)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:alertMsg delegate:self cancelButtonTitle:cancelMsg otherButtonTitles:okMsg, nil];
		self.mAlert = alert;
		
		[self.mAlert setDelegate:self];
	}
	
	self.mAlert.hidden = YES;
	[self.mAlert show];
}





#pragma mark -
#pragma mark delegate functions
//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//add the target of button
	for(UIButton *btn in _buttons)
	{
		if(btn.tag == _touchDownIndex)
		{
			[btn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
			break;
		}
	}
	
	if(buttonIndex == 1) //replace
	{
		if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(overWritePresetByIndex:)])
		{
			[self.delegate overWritePresetByIndex:_touchDownIndex];
		}
	}
}
- (void)didPresentAlertView:(UIAlertView *)alertView
{
	self.mAlert.hidden = NO;
	
	NoirAppDelegate * del = (NoirAppDelegate*)[[UIApplication sharedApplication] delegate];
	self.mAlert.transform = del.curTransfrom;
}



#pragma mark -
#pragma mark timer functions
-(void)startTimer
{
	self._timer =  [NSTimer scheduledTimerWithTimeInterval:0.5
													target:self 
												  selector:@selector(timerFireMethod:) 
												  userInfo:nil 
												   repeats:NO];
}
-(void)stopTimer
{
	if(self._timer && [self._timer isValid])
	{
		[self._timer invalidate];
	}	
}
-(void)FireTheTimerMethod
{
	[self._timer fire];
}
-(void)timerFireMethod:(NSTimer*)theTimer
{
	[self stopTimer];
	
	//remove the target of button
	for(UIButton *btn in _buttons)
	{
		if(btn.tag == _touchDownIndex)
		{
			[btn removeTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
			break;
		}
	}
	

	//alert
	[self alertYouAction:@"Update Preset" withMsg:@"Replace this preset with the current settings?" withOK:@"Replace" withCancel:@"Cancel"];
}




@end
