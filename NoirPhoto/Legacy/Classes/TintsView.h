//
//  TintsView.h
//  Noir
//
//  Created by mac on 10-7-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//PS:this module now only&should can support 4 tints item, can not less&more than 4 tints  


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>



typedef enum{
	pfMartix,
	pfLine
} PostionFormat;



@class TintsView;
@protocol TintsViewDelegate <NSObject>
@optional
//the return index sequence is:
//0, 1
//2, 3
-(void)tintsButtonChooseIndex:(NSInteger)index data:(id)data; //return index & data for choose
@end


@interface TintsView : UIView {

	NSArray *_buttons;
	NSArray *_items;
	
	float _btnWidth;  //in this module, the widht default frame.width/2 for pfMartix, frame.width/4 for pfLine, can not be changed by outside
	float _btnHeight; //in this module, the height default frame.height/2 for pfMartix, frame.width for pfLine, can not be changed by outside
	
	PostionFormat _posformat;
}

@property (nonatomic, weak) id<TintsViewDelegate> delegate;


#pragma mark -
#pragma mark out use function @overwrite system function
//the item is NSDictionary type, the key-value pair include: "data"->data, "image"->image
//if set height=0 use default height and width
- (id)initWithFrame:(CGRect)frame items:(NSArray*)items dele:(id)dele posformat:(PostionFormat)posformat btnWidth:(float)width btnHeight:(float)height; 



#pragma mark -
#pragma mark in/out use functions
-(void)setButtonsForItems:(NSArray*)items; //additional using this function if there are no items when useing "initWithFrame" function, the paramater "items" is just like the "initWithFrame" 
-(void)chooseButtonForIndex:(NSInteger)index bReturnToDelegate:(BOOL)bReturnTodele; //each time only a button has disable state
-(void)setBackGroundWithImage:(UIImage*)bgImage orColor:(UIColor*)bgColor; //first Priority is image, if image==nil use color, if color==nil use default clearColor


#pragma mark -
#pragma mark in use functions
-(void)itemAction:(id)sender;




@end
