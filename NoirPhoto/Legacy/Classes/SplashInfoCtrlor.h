//
//  SplashInfoCtrlor.h
//
//  Created by mac on 11-3-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SplashInfoCtrlor : UIViewController {

	IBOutlet UIScrollView *scrollView;
	IBOutlet UIImageView *iimageView;
	IBOutlet UIButton *backBtn;
	IBOutlet UIImageView *backView;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *iimageView;
@property (nonatomic, retain) UIButton *backBtn;
@property (nonatomic, retain) UIImageView *backView;

#pragma mark -
#pragma mark in use functions
-(IBAction)backAction:(id)sender;

@end
