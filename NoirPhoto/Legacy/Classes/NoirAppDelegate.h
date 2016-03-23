//
//  NoirAppDelegate.h
//  Noir
//
//  Created by jack on 6/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accelerater.h"
#import "SplashCtrlor.h"

@class NoirViewController;

@interface NoirAppDelegate : NSObject <UIApplicationDelegate,SplashCtrlorDelegate> {
    UIWindow *window;
    NoirViewController *viewController;
	UINavigationController *navigationCtrlor;
	
	CGAffineTransform    curTransfrom;
	BOOL bForceAcceler;
	AccelerXYState curXYState;
	
	SplashCtrlor *_splash;
	UINavigationController *_splashNav;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NoirViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationCtrlor;
@property (nonatomic)         CGAffineTransform    curTransfrom;
@property (nonatomic)         BOOL bForceAcceler;
@property (nonatomic) AccelerXYState curXYState;


- (void)changedAccerateXY:(AccelerXYState)xyState;
-(BOOL)checkPhotoExistFromPath:(NSString*)path;

@end

