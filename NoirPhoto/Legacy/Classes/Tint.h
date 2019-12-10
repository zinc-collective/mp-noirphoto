//
//  Tint.h
//  Noir
//
//  Created by mac on 10-7-12.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Tint : NSObject {

	NSInteger index;
	UIColor *color;
}

@property (nonatomic) NSInteger index;
@property (nonatomic, retain) UIColor *color;

@end
