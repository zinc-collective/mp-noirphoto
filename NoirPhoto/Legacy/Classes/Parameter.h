//
//  Parameter.h
//  Noir
//
//  Created by mac on 10-7-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tint.h"

@interface Parameter : NSObject {

	float     ellipseCenterX;
	float     ellipseCenterY;
	float     ellipseA;
	float     ellipseB;
	float     ellipseAngle;
}


@property (nonatomic) float           ellipseCenterX;
@property (nonatomic) float           ellipseCenterY;
@property (nonatomic) float           ellipseA;
@property (nonatomic) float           ellipseB;
@property (nonatomic) float           ellipseAngle;


@end
