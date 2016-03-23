//
//  SplashInfoCtrlor.m
//
//  Created by mac on 11-3-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplashInfoCtrlor.h"

@implementation SplashInfoCtrlor

@synthesize scrollView;
@synthesize iimageView;
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

- (void)viewDidLoad
{
	self.scrollView.backgroundColor = [UIColor clearColor];
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	
	//change image and contentsize
	UIImage *descImage = [UIImage imageNamed:@"info_desc-iPad.png"];
	CGRect imageViewRect = CGRectMake((self.view.frame.size.width-descImage.size.width)/2, 0.0, descImage.size.width, descImage.size.height);
	
	self.iimageView.frame = imageViewRect;
	self.iimageView.image = descImage;
	
	self.scrollView.contentSize = CGSizeMake(768.0, descImage.size.height);
	
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		UIImage *descImage = [UIImage imageNamed:@"info_desc-iPad.png"];
		CGRect imageViewRect = CGRectMake((768.0-descImage.size.width)/2, 0.0, descImage.size.width, descImage.size.height);
		
		self.iimageView.frame = imageViewRect;
		self.iimageView.image = descImage;
		
		self.scrollView.contentSize = CGSizeMake(768.0, descImage.size.height);
		self.backView.image = [UIImage imageNamed:@"info_bg-iPad.png"];
	}
	else
	{
		UIImage *descImage = [UIImage imageNamed:@"info_desc_landscape_splash-iPad.png"];
		CGRect imageViewRect = CGRectMake((1024.0-descImage.size.width)/2, 0.0, descImage.size.width, descImage.size.height);
		
		self.iimageView.frame = imageViewRect;
		self.iimageView.image = descImage;
		
		self.scrollView.contentSize = CGSizeMake(1024.0, descImage.size.height);
		self.backView.image = [UIImage imageNamed:@"info_bg_landscape-iPad.png"];
	}
	
	return YES;
}



#pragma mark -
#pragma mark in use functions
-(IBAction)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}



@end
