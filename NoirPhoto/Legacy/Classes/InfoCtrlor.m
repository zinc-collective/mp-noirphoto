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
//		if (IS_IPHONE_5)
//            self.view.frame = CGRectMake(0, 0, 320, 568);
    
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




#pragma mark -
#pragma mark in use functions
-(IBAction)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
