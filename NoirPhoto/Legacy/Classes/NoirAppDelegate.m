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




@implementation NoirAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationCtrlor;
@synthesize curTransfrom;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch  
	self.curTransfrom = CGAffineTransformIdentity;
	

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
