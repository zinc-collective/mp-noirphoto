//
//  TintsView.m
//  Noir
//
//  Created by mac on 10-7-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TintsView.h"



@implementation TintsView

@synthesize delegate;


#pragma mark -
#pragma mark out use function @overwrite system function
- (id)initWithFrame:(CGRect)frame items:(NSArray*)items dele:(id)dele posformat:(PostionFormat)posformat btnWidth:(float)width btnHeight:(float)height
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		self.delegate = dele;
		_posformat = posformat;
		
		if(_posformat == pfMartix)
		{
//			_btnWidth = frame.size.width/2;
//			_btnHeight = frame.size.height/2;
			
			if(width == 0)
			{
				_btnWidth = frame.size.width/2;
			}
			else
			{
				_btnWidth = width;
			}
			
			if(height == 0)
			{
				_btnHeight = frame.size.height/2;
			}
			else
			{
				_btnHeight = height;
			}

		}
		else if(_posformat == pfLine)
		{
//			_btnWidth = frame.size.width/4;
//			_btnHeight = frame.size.height;
			
			if(width == 0)
			{
				_btnWidth = frame.size.width/4;
			}
			else
			{
				_btnWidth = width;
			}
			
			if(height == 0)
			{
				_btnHeight = frame.size.height;
			}
			else
			{
				_btnHeight = height;
			}
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
	//got the new items
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
	
	float posX = 0.0;
	float posY = 0.0;
	
	for(int i=0; i<[items count]; i++)
	{
		NSDictionary *itemDic = [items objectAtIndex:i];
		UIImage *btnImage    = [itemDic valueForKey:@"image"];
		UIImage *btnImageSel = [itemDic valueForKey:@"image_sel"];
		
		UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		itemBtn.frame = CGRectMake(posX, posY, _btnWidth, _btnHeight);
		[itemBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
		[itemBtn setBackgroundImage:btnImageSel forState:UIControlStateHighlighted];
		[itemBtn setBackgroundImage:btnImageSel forState:UIControlStateSelected];
		[itemBtn setBackgroundImage:btnImageSel forState:UIControlStateDisabled];
		itemBtn.tag = i;
		[itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.exclusiveTouch = YES;
		[self addSubview:itemBtn];
			
		//add btns into array
		[buttons addObject:itemBtn];
		
		//init next button's x,y position
		if(_posformat == pfMartix)
		{
			if(i==0)
			{
				posX = self.frame.size.width - _btnWidth;
				posY = 0.0;
			}
			else if(i == 1)
			{
				posX = 0.0;
				posY = self.frame.size.height - _btnHeight;
			}
			else if(i == 2)
			{
				posX = self.frame.size.width - _btnWidth;
				posY = self.frame.size.height - _btnHeight;
			}
		}
		else if(_posformat == pfLine)
		{
			float blank = (self.frame.size.width - _btnWidth*4)/3;
			
			posX = (_btnWidth+blank)*(i+1);
			posY = 0.0;
		}
		
	}
	
    _buttons = buttons;
	
}
-(void)chooseButtonForIndex:(NSInteger)index bReturnToDelegate:(BOOL)bReturnTodele
{
	if(_buttons == nil || [_buttons count] ==0) return;
	
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
		if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(tintsButtonChooseIndex:data:)])
		{
			NSDictionary *itemDic = [_items objectAtIndex:index];
			if(itemDic == nil) return;
			
			id data = (id)[itemDic valueForKey:@"data"];
			[self.delegate tintsButtonChooseIndex:index data:data];
			
//			NSLog(@"selected tint: %d", index);
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






#pragma mark -
#pragma mark in use functions
-(void)itemAction:(id)sender
{
	UIButton *itemBtn = (UIButton*)sender;
	[self chooseButtonForIndex:itemBtn.tag bReturnToDelegate:YES];
}




@end
