//
//  SplashCtrlor.h
//
//  Created by mac on 10-11-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Accelerater.h"


@class SplashCtrlor;
@protocol SplashCtrlorDelegate <NSObject>
@optional
-(void)splashAlbumActioned:(id)sender;
-(void)splashInfoActioned;
-(void)splashSelectedPhoto:(UIImage*)photo;
@end


@interface SplashCtrlor : UIViewController <UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{

	IBOutlet UIButton *albumBtn;
	IBOutlet UIButton *infoBtn;
	IBOutlet UIImageView *backView;
	
	UIPopoverController *_imagePickerPopover;
	UIImagePickerController *_imagePicker;
	
	UIInterfaceOrientation _curOrientation;
	BOOL bCanRotate;
	
	UIView *_maskView;
	UIActivityIndicatorView *_spinner;
    
    UIButton *helpBtn;
}

@property (nonatomic, weak) id<SplashCtrlorDelegate> delegate;
@property (nonatomic, retain) UIButton *albumBtn;
@property (nonatomic, retain) UIButton *infoBtn;
@property (nonatomic, retain) UIImageView *backView;
@property (nonatomic) BOOL bCanRotate;


#pragma mark -
#pragma mark in use functions
-(IBAction)infoAction:(id)sender;
-(IBAction)albumAction:(id)sender;
-(void)saveOriginPhoto:(UIImage*)image;

//-(void)changeForAccerateXY:(AccelerXYState)xyState;

#pragma mark -
#pragma mark 为限制图片大小做的函数
-(BOOL)checkIfPureiPhone4NotIncludeIPod4;
-(UIImage*)limitedSourcePhoto:(UIImage*)source forLimitPixel:(float)limit;
-(CGRect)photoRenderRectForImageSize:(CGSize)imageSize withImageViewRect:(CGRect)viewRect;
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
-(UIImage*)imageAddAlphaForImage:(UIImage *)image;
-(void)startWait;
-(void)stopWait;


@end
