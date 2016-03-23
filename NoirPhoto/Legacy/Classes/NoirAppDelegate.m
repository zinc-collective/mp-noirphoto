//
//  NoirAppDelegate.m
//  Noir
//
//  Created by jack on 6/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NoirAppDelegate.h"
#import "NoirViewController.h"
#import "InfoCtrlor.h"


#define save_origin_photo_path		@"/Documents/origin_photo.jpg"


//add version
#import "VersionWatermark.h"

@interface UIWindow (PBRedsafi)

- (void)layoutSubviews;

@end

@implementation UIWindow (PBRedsafi)

- (void)layoutSubviews{
	
//bret
//#ifdef MACRO__VERSION__
//	UIView *view = [self viewWithTag:1000];
//	[self bringSubviewToFront:view];
//#endif
}

@end



@implementation NoirAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationCtrlor;
@synthesize curTransfrom;
@synthesize bForceAcceler;
@synthesize curXYState;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch  
	self.curTransfrom = CGAffineTransformIdentity;
	self.bForceAcceler = YES;
	

	UINavigationController *navCtrlor = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.navigationCtrlor = navCtrlor;
	[self.navigationCtrlor setNavigationBarHidden:YES];
	
    [window setRootViewController:viewController];

	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		BOOL bExist = [self checkPhotoExistFromPath:save_origin_photo_path];
		if(bExist)
		{
			[window addSubview:self.navigationCtrlor.view];
		}
		else
		{
			_splash = [[SplashCtrlor alloc] initWithNibName:@"Splash-iPad" bundle:nil];
			_splash.delegate = self;
			_splash.bCanRotate = YES;
			
			_splashNav = [[UINavigationController alloc] initWithRootViewController:_splash];
			[_splashNav setNavigationBarHidden:YES];
			
			[window addSubview:_splashNav.view];
		}
	}
	else
	{
		[window addSubview:self.navigationCtrlor.view];
	}
	
	
	// Changed for IOS6 support
	// http://grembe.wordpress.com/2012/09/19/here-is-what-i/
    // [window addSubview:viewController.view];
	//bret: these are probably redundant under storyboard
    //[window setRootViewController:viewController];
    [window makeKeyAndVisible];

    //[window makeKeyAndVisible];
	
	
	//add version
//bret
//#ifdef MACRO__VERSION__
//	VersionWatermark *watermark = [[VersionWatermark alloc] initWithFrame:CGRectMake(0.0, 0.0, window.bounds.size.width, 30.0)];
//	watermark.tag = 1000;
//	[watermark showInView:window];
//	[watermark release];
//#endif
	
	return YES;
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    NSLog (@"supportedInterfaceOrientationsForWindow");
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self.viewController savePresetToUserDefault];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self.viewController savePresetToUserDefault];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	self.bForceAcceler = YES;
}



- (void)changedAccerateXY:(AccelerXYState)xyState
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		UIViewController *visible = [self.navigationCtrlor visibleViewController];
		
		if([visible isKindOfClass:[InfoCtrlor class]])
		{
			InfoCtrlor *infoClr = (InfoCtrlor*)visible;
			[infoClr changeContentForAccerateXY:xyState];
		}
	}
}
-(BOOL)checkPhotoExistFromPath:(NSString*)path
{
	NSString *filePath = [NSHomeDirectory() stringByAppendingString:path];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) 
	{	
		return YES;
	}
	
	return NO;
}



#pragma mark -
#pragma mark delegate functions
//SplashCtrlorDelegate
-(void)splashSelectedPhoto:(UIImage*)photo
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[_splashNav.view removeFromSuperview];
		_splashNav.view.alpha = 0.0;
		
		_splash.view.alpha = 0.0;
		_splash = nil;
		
		_splashNav = nil;
		
		[window addSubview:self.navigationCtrlor.view];
	}
}




@end
