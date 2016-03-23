//
//  Accelerater.m
//
//  Created by mac on 09-5-19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Accelerater.h"
#import "NoirAppDelegate.h"

#define kAccelerometerFrequency 40



@implementation Accelerater
@synthesize delegate;



#pragma mark -
#pragma mark system functions @for out use
- (id)initWithType:(AccelerateType)accelerType 
{
	if(self = [super init]) 
	{
		_accelerateType = accelerType;
		
		//init
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	}
	return self;
}




#pragma mark -
#pragma mark delegate functions
//UIAccelerometerDelegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	//calculatle if shake
	if(_accelerateType == accelerShake)
	{
		static NSInteger shakeCount = 0;
		static NSDate *shakeStart;
		
		NSDate *now = [[NSDate alloc] init];
		NSDate *checkDate = [[NSDate alloc] initWithTimeInterval:1.5f sinceDate:shakeStart];
		
		if([now compare:checkDate] == NSOrderedDescending || shakeStart == nil)
		{
			shakeCount = 0;
			shakeStart = [[NSDate alloc] init];
		}
		
		if(fabs(acceleration.x) > 2.0 || fabs(acceleration.y) > 2.0 || fabs(acceleration.z) > 2.0)
		{
			shakeCount++;
			if(shakeCount>4)
			{
				//return to delegate
				if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(iPhoneShakeFromAccelerater)])
				{
					[self.delegate iPhoneShakeFromAccelerater];
				}
				
				shakeCount = 0;
				shakeStart = [[NSDate alloc] init];
			}
		}
		
	}
	//calculate if checkXY
	else if(_accelerateType == accelerXY)
	{
		
		//看是否启动时强制使用重力检测
		NoirAppDelegate * appDelegate = (NoirAppDelegate*)[[UIApplication sharedApplication] delegate];
		if(appDelegate.bForceAcceler)
		{
			appDelegate.bForceAcceler = NO;
			
			float kFMin = 0.5f;
			float x = acceleration.x;
			float y = acceleration.y;
						
			
			if(fabs(x)<kFMin && fabs(y)>kFMin && y < 0)
			{
				_xyState = accelerXYStatePortrait;
			}
			else if(fabs(x)<kFMin && fabs(y)>kFMin && y > 0)
			{
				_xyState = accelerXYStatePortraitUpsideDown;
			}
			else if(fabs(x)>kFMin && fabs(y)<kFMin && x > 0)
			{
				_xyState = accelerXYStateLandscapeLeft;
			}
			else if(fabs(x)>kFMin && fabs(y)<kFMin && x < 0)
			{
				_xyState = accelerXYStateLandscapeRight;
			}
			else
			{
				_xyState = accelerXYStatePortrait;
			}

			
			//return to delegate
			if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(iPhoneRotateForState:)])
			{
				[self.delegate iPhoneRotateForState:_xyState];
			}
			
			return;
		}
		
		
		
		BOOL doTransform = NO;
		const float kMinValue = 0.5f;
		const float kMaxValue = 1.f-kMinValue;
		const int NUM_TRIES = 4;
		static int numTries = 0;
		
		//check the acceleration
		if(fabs(acceleration.x) >= kMaxValue && fabs(acceleration.y) <= kMinValue && _isPortrait)
		{
			numTries++;
			if(numTries>NUM_TRIES)
			{
				doTransform = YES;
				_isPortrait = NO;
				_isInverted = acceleration.x<0.f;
			}
		}
		else if(fabs(acceleration.y) >= kMaxValue  && fabs(acceleration.x) <= kMinValue && !_isPortrait)
		{
			numTries++;
			if(numTries>NUM_TRIES)
			{
				doTransform = YES;
				_isPortrait = YES;
				_isInverted = acceleration.y>0.f;
			}
		}


		//adjust the xy state
		if(_isPortrait)
		{
			if(_isInverted)
			{
				_xyState = accelerXYStatePortraitUpsideDown;
			}
			else
			{
				_xyState = accelerXYStatePortrait;
			}
		}
		else
		{
			if(_isInverted)
			{
				_xyState = accelerXYStateLandscapeRight;
			}
			else
			{
				_xyState = accelerXYStateLandscapeLeft;
			}

		}

		//return
		if(doTransform)
		{
			//return to delegate
			if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(iPhoneRotateForState:)])
			{
				[self.delegate iPhoneRotateForState:_xyState];
			}
		}
			
	}
	
}






@end
