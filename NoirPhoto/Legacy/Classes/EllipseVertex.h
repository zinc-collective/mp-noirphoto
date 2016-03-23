//
//  EllipseVertex.h
//  Quartz
//
//  Created by jack on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EllipseVertex : NSObject {
	
	CGPoint left;
	CGPoint right;
	CGPoint top;
	CGPoint bottom;

}


- (CGRect) EllipseRect;

- (float) xAxis;
- (float) yAxis;

- (float) newYAxisWithPoint:(CGPoint)pt;

- (void) moveBottomTo:(CGPoint)pt;
- (void) moveRightTo:(CGPoint)pt;
- (void) moveLeftTo:(CGPoint)pt;
- (void) moveTopTo:(CGPoint)pt;

- (void) moveOffset:(CGPoint)offset;

- (CGRect) leftVertexBox;
- (CGRect) rightVertexBox;
- (CGRect) topVertexBox;
- (CGRect) bottomVertexBox;

- (CGPoint) bottomVertex;
- (CGPoint) topVertex;
- (CGPoint) leftVertex;
- (CGPoint) rightVertex;

- (void) horizontallyScale:(CGPoint)l r:(CGPoint)r;
- (void) verticallyScale:(CGPoint)t b:(CGPoint)b;

- (CGPoint) center;

@end
