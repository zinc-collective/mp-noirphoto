//
//  Accelerater.h
//
//  Created by mac on 09-5-19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
	accelerShake,
	accelerXY
} AccelerateType;


typedef enum{
	accelerXYStatePortrait,
	accelerXYStatePortraitUpsideDown,
	accelerXYStateLandscapeLeft,
	accelerXYStateLandscapeRight
} AccelerXYState;



@class Accelerater;
@protocol AccelerateDelegate <NSObject>
@optional
-(void)iPhoneShakeFromAccelerater;							//iPhone shake
-(void)iPhoneRotateForState:(AccelerXYState)xyState;		//rotate to x or y
@end



@interface Accelerater : NSObject <UIAccelerometerDelegate> {

	AccelerateType _accelerateType;
	AccelerXYState _xyState;
	
	BOOL _isPortrait;
	BOOL _isInverted;
}

@property (nonatomic, weak) id<AccelerateDelegate> delegate;



#pragma mark -
#pragma mark system functions @for out use
- (id)initWithType:(AccelerateType)accelerType; 



@end
