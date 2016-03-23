//
//  InfoCtrlor.m
//
//  Created by mac on 10-12-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoCtrlor.h"
#import "NoirAppDelegate.h"
#import "DeviceDetect.h"

@implementation InfoCtrlor
@synthesize backBtn;
@synthesize backView;

#pragma mark -
#pragma mark system functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		if (IS_IPHONE_5)
            self.view.frame = CGRectMake(0, 0, 320, 568);
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
		_scrollView.backgroundColor = [UIColor clearColor];
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		
		//add image
		NSString *imageName = @"info_desc.png";
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			imageName = @"info_desc-iPad.png";
		}
		
		UIImage *descImage = [UIImage imageNamed:imageName];
		CGRect imageViewRect = CGRectMake((self.view.frame.size.width-descImage.size.width)/2, 0.0, descImage.size.width, descImage.size.height);
		
		_imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
		_imageView.image = descImage;
		[_scrollView addSubview:_imageView];
		
		_scrollView.contentSize = CGSizeMake(320.0, descImage.size.height);
		[self.view insertSubview:_scrollView atIndex:1];
	}
	else
	{
		NoirAppDelegate * delegate = (NoirAppDelegate*)[[UIApplication sharedApplication] delegate];
		[self initContentForAccerateXY:delegate.curXYState];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
}





#pragma mark -
#pragma mark in use functions
-(IBAction)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)initContentForAccerateXY:(AccelerXYState)xyState
{
	CGRect scrollRect;
	NSString *imageName;
	float scrollWidth;
	
	if(xyState == accelerXYStatePortrait || xyState == accelerXYStatePortraitUpsideDown)
	{
		scrollRect = CGRectMake(0.0, 0.0, 768.0, 1024.0);
		imageName = @"info_desc-iPad.png";
		scrollWidth = 768.0;
	}
	else if(xyState == accelerXYStateLandscapeLeft || xyState == accelerXYStateLandscapeRight)
	{
		scrollRect = CGRectMake(-128.0, 128.0, 1024.0, 768.0);
		imageName = @"info_desc_landscape-iPad.png";
		scrollWidth = 1024.0;
	}


	if(_scrollView == nil)
	{
		_scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
		_scrollView.backgroundColor = [UIColor clearColor];
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		
		//add image
		UIImage *descImage = [UIImage imageNamed:imageName];
		CGRect imageViewRect = CGRectMake((scrollWidth-descImage.size.width)/2, 0.0, descImage.size.width, descImage.size.height);
		
		_imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
		_imageView.image = descImage;
		[_scrollView addSubview:_imageView];
		
		_scrollView.contentSize = CGSizeMake(scrollWidth, descImage.size.height);
		[self.view insertSubview:_scrollView atIndex:1];
		
		
		//do some transform
		CGAffineTransform transfm;
		if(xyState == accelerXYStatePortrait)
		{
			transfm = CGAffineTransformRotate(CGAffineTransformIdentity, 0.0);
			self.backView.image = [UIImage imageNamed:@"info_bg-iPad.png"];
		}
		else if(xyState == accelerXYStatePortraitUpsideDown)
		{
			transfm = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
			self.backView.image = [UIImage imageNamed:@"info_bg_updown-iPad.png"];
		}
		else if(xyState == accelerXYStateLandscapeLeft)
		{
			transfm = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI/2);
			self.backView.image = [UIImage imageNamed:@"info_bg_landscape_left-iPad.png"];
		}
		else if(xyState == accelerXYStateLandscapeRight)
		{
			transfm = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
			self.backView.image = [UIImage imageNamed:@"info_bg_landscape_right-iPad.png"];
		}
		
		_scrollView.transform = transfm;
		
	}
}

-(void)changeContentForAccerateXY:(AccelerXYState)xyState
{	
//	if(_scrollView != nil && [_scrollView superview])
//	{
//		[_imageView removeFromSuperview];
//		_imageView = nil;
//		
//		[_scrollView removeFromSuperview];
//		[_scrollView release];
//		_scrollView = nil;
//	}
//	
//	[self initContentForAccerateXY:xyState];
	
	
	
	
	
	CGRect scrollRect;
	NSString *imageName;
	float scrollWidth;
	
	if(xyState == accelerXYStatePortrait || xyState == accelerXYStatePortraitUpsideDown)
	{
		scrollRect = CGRectMake(0.0, 0.0, 768.0, 1024.0);
		imageName = @"info_desc-iPad.png";
		scrollWidth = 768.0;
	}
	else if(xyState == accelerXYStateLandscapeLeft || xyState == accelerXYStateLandscapeRight)
	{
		scrollRect = CGRectMake(-128.0, 128.0, 1024.0, 768.0);
		imageName = @"info_desc_landscape-iPad.png";
		scrollWidth = 1024.0;
	}
	
	
	[UIView beginAnimations:@"rotate" context:nil]; 
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 
	[UIView setAnimationDuration:0.3f];
	
	
	//change image
	UIImage *descImage = [UIImage imageNamed:imageName];
	CGRect imageViewRect = CGRectMake((scrollWidth-descImage.size.width)/2, 0.0, descImage.size.width, descImage.size.height);
	
	_imageView.frame = imageViewRect;
	_imageView.image = descImage;
	
	_scrollView.frame = scrollRect;
	_scrollView.contentSize = CGSizeMake(scrollWidth, descImage.size.height);
	

	//do some transform
	CGAffineTransform transfm;
	if(xyState == accelerXYStatePortrait)
	{
		transfm = CGAffineTransformRotate(CGAffineTransformIdentity, 0.0);
		self.backView.image = [UIImage imageNamed:@"info_bg-iPad.png"];
		
		_scrollView.transform = transfm;
		_scrollView.contentSize = CGSizeMake(scrollWidth, descImage.size.height);
		_scrollView.frame = scrollRect;
	}
	else if(xyState == accelerXYStatePortraitUpsideDown)
	{
		transfm = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
		self.backView.image = [UIImage imageNamed:@"info_bg_updown-iPad.png"];
		
		_scrollView.transform = transfm;
		_scrollView.contentSize = CGSizeMake(scrollWidth, descImage.size.height);
		_scrollView.frame = scrollRect;
	}
	else if(xyState == accelerXYStateLandscapeLeft)
	{
		transfm = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI/2);
		self.backView.image = [UIImage imageNamed:@"info_bg_landscape_left-iPad.png"];
		
		_scrollView.transform = transfm;
		_scrollView.contentSize = CGSizeMake(scrollWidth, descImage.size.height);
	}
	else if(xyState == accelerXYStateLandscapeRight)
	{
		transfm = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
		self.backView.image = [UIImage imageNamed:@"info_bg_landscape_right-iPad.png"];
		
		_scrollView.transform = transfm;
		_scrollView.contentSize = CGSizeMake(scrollWidth, descImage.size.height);
	}
	
//	_scrollView.transform = transfm;
//	_scrollView.contentSize = CGSizeMake(scrollWidth, descImage.size.height);
	//_scrollView.frame = scrollRect;
	
	
	[UIView commitAnimations];

}


@end
