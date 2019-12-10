//
//  VersionWatermark.m
//  FlickrPlug
//
//  Created by jack on 10-4-20.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import "VersionWatermark.h"
#include <sys/types.h>
#include <sys/sysctl.h>



#define VERSION_PLIST			@"version_info.plist"
#define INFO_PLIST				@"Info.plist"

@interface VersionWatermark (Private)
- (void) removeMySelf;
@end


@implementation VersionWatermark


- (id) initWithFrame:(CGRect)frame{
	if(self = [super initWithFrame:frame]){

		self.backgroundColor = [UIColor clearColor];

		float w = frame.size.width;
		float h = frame.size.height;
		UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, w, h)];
		backGroundView.backgroundColor = [UIColor blackColor];
		backGroundView.alpha = 0.5;
		[self addSubview:backGroundView];

		_version = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, w-30, 30)];
		_version.textAlignment = NSTextAlignmentCenter;
		_version.textColor = [UIColor whiteColor];
		_version.backgroundColor = [UIColor clearColor];
		_version.font = [UIFont systemFontOfSize:13];
		[self addSubview:_version];


        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
		close.alpha = 0.65;
		close.frame = CGRectMake(w-30, 0.0, 30.0, 30.0);
		[close setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
		[close addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:close];

		[self loadingVersion];

	}
    return self;
}

- (NSString *)getDeviceName
{
	// Device Name:
	// iPone1,2 = 3G iPhone
	// iPhone2,1 = 3GS iPhone
	// iPod1,2 = 1st gen iPod
	// iPod2,1 = 2nd gen iPod
	// iPad... = iPad
	// i386 = simulator
	//

	size_t size;

	// Set 'oldp' parameter to NULL to get the size of the data
	// returned so we can allocate appropriate amount of space
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);

	// Allocate the space to store name
	char *name = (char*) malloc(size);

	// Get the platform name
	sysctlbyname("hw.machine", name, &size, NULL, 0);

	// Place name into a string
	NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];

	// Done with this
	free(name);

	return machine;
}


- (void) loadingVersion{
	NSString * path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:INFO_PLIST];
	NSFileManager *fileSys = [NSFileManager defaultManager];

	NSString * version_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:VERSION_PLIST];

	NSString *v = @"";

	if([fileSys fileExistsAtPath:path]){

		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:path];
		NSString *version = [settingsDict objectForKey:@"CFBundleVersion"];


		NSDictionary *buildInfoDict = [NSDictionary dictionaryWithContentsOfFile:version_path];
		NSString *build_version = [buildInfoDict objectForKey:@"build version"];

		 v = [NSString stringWithFormat:@"%@ - %@", version, build_version];


	}
	else{
		v = @"unknow version!";
	}

	NSString *text = [NSString stringWithFormat:@"%@, type: %@", v, [self getDeviceName]];

	_version.text = text;

}

- (void) showInView:(UIView*)view{
	if(![self superview]){
		[view addSubview:self];
	}
	self.alpha = 0;

	[UIView beginAnimations:@"show watermark view" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25];

	self.alpha = 1.0;

	[UIView commitAnimations];
}

- (void) closeAction:(id)sender{
	[self removeMySelf];
}


- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if(finished ){
		if([animationID isEqualToString:@"hide watermark view"])
		{
			if([self superview]){
				[self removeFromSuperview];
			}
		}
	}
}

- (void) removeMySelf{

	[UIView beginAnimations:@"hide watermark view" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

	self.alpha = 0;

	[UIView commitAnimations];
}




@end