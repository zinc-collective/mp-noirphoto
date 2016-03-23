//
//  Preset.h
//  Noir
//
//  Created by mac on 10-7-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tint.h"


@interface Preset : NSObject {

	NSInteger index;
	float     expInside;
	float     expOutside;
	float     contrast;
	NSInteger tintIndex;
	float     ellipseCenterX;
	float     ellipseCenterY;
	float     ellipseA;
	float     ellipseB;
	float     ellipseAngle;
	BOOL      selected;
}

@property (nonatomic) NSInteger       index;
@property (nonatomic) float           expInside;
@property (nonatomic) float           expOutside;
@property (nonatomic) float           contrast;
@property (nonatomic) NSInteger		  tintIndex;
@property (nonatomic) float           ellipseCenterX;
@property (nonatomic) float           ellipseCenterY;
@property (nonatomic) float           ellipseA;
@property (nonatomic) float           ellipseB;
@property (nonatomic) float           ellipseAngle;
@property (nonatomic) BOOL            selected;


@end
