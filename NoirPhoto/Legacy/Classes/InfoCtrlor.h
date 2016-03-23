//
//  InfoCtrlor.h
//
//  Created by mac on 10-12-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface InfoCtrlor : UIViewController {

	UIScrollView *_scrollView;
	UIImageView *_imageView;
	IBOutlet UIButton *backBtn;
	IBOutlet UIImageView *backView;
}
@property (nonatomic, retain) UIButton *backBtn;
@property (nonatomic, retain) UIImageView *backView;

#pragma mark -
#pragma mark in use functions
-(IBAction)backAction:(id)sender;


@end
