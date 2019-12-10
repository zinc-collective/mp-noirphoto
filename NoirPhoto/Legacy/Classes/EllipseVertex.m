//
//  EllipseVertex.m
//  Quartz
//
//  Created by jack on 5/31/10.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import "EllipseVertex.h"


@implementation EllipseVertex

- (id)init{
	if(self = [super init]){
		left.x = 110.0;
		left.y = 120.0;

		right.x = 210;
		right.y = 120.0;

		top.x = 160.0;
		top.y = 50.0;

		bottom.x = 160.0;
		bottom.y = 190.0;
	}

	return self;
}

- (CGRect) EllipseRect{

	float x = left.x;
	float y = top.y;
	float w = right.x - left.x;
	float h = bottom.y - top.y;

	return CGRectMake(x, y, w, h);
}

- (CGPoint) bottomVertex{
	return bottom;
}
- (CGPoint) topVertex{
	return top;
}
- (CGPoint) leftVertex{
	return left;
}
- (CGPoint) rightVertex{
	return right;
}

- (float) xAxis{
	return right.x - left.x;
}

- (float) yAxis{
	return bottom.y - top.y;
}

- (float) newYAxisWithPoint:(CGPoint)pt{
	return pt.y - top.y;
}

- (void) moveBottomTo:(CGPoint)pt{

	float oldHeight = [self yAxis];
	float oldWidth =  [self xAxis];

	float newHeight = [self newYAxisWithPoint:pt];

	float newWidth = 0;
	if(newHeight && oldHeight){
		newWidth = (newHeight*oldWidth)/oldHeight;

		left.x = top.x - newWidth/2.0;
		left.y = top.y + newHeight/2.0;

		right.x = top.x + newWidth/2.0;
		right.y = left.y;
	}

	bottom.y = pt.y;

}

- (void) moveRightTo:(CGPoint)pt{

	float oldHeight = [self yAxis];
	float oldWidth =  [self xAxis];

	float newWidth = pt.x - left.x;

	float newHeight = 0;
	if(newWidth && oldWidth){
		newHeight = (newWidth*oldHeight)/oldWidth;

		top.x = left.x + newWidth/2.0;
		top.y = left.y - newHeight/2.0;

		bottom.x = top.x;
		bottom.y = top.y + newHeight;
	}

	right.x = pt.x;
}

- (void) moveLeftTo:(CGPoint)pt{
	float oldHeight = [self yAxis];
	float oldWidth =  [self xAxis];

	float newWidth = right.x - pt.x;

	float newHeight = 0;
	if(newWidth && oldWidth){
		newHeight = (newWidth*oldHeight)/oldWidth;

		top.x = right.x - newWidth/2.0;
		top.y = right.y - newHeight/2.0;

		bottom.x = top.x;
		bottom.y = top.y + newHeight;
	}

	left.x = pt.x;
}
- (void) moveTopTo:(CGPoint)pt{

	float oldHeight = [self yAxis];
	float oldWidth =  [self xAxis];

	float newHeight = bottom.y - pt.y;

	float newWidth = 0;
	if(newHeight && oldHeight){
		newWidth = (newHeight*oldWidth)/oldHeight;

		left.x = bottom.x - newWidth/2.0;
		left.y = bottom.y - newHeight/2.0;

		right.x = left.x + newWidth;
		right.y = left.y;
	}

	top.y = pt.y;
}

- (CGRect) leftVertexBox{
	return CGRectMake(left.x, left.y, 0.0f, 0.0f);
}

- (CGRect) rightVertexBox{
	return CGRectMake(right.x, right.y, 0.0f, 0.0f);
}
- (CGRect) topVertexBox{
	return CGRectMake(top.x, top.y, 0.0f, 0.0f);
}
- (CGRect) bottomVertexBox{
	return CGRectMake(bottom.x, bottom.y, 0.0f, 0.0f);
}

- (void) moveOffset:(CGPoint)offset{

	left.x += offset.x;
	left.y += offset.y;

	top.x += offset.x;
	top.y += offset.y;

	right.x += offset.x;
	right.y += offset.y;

	bottom.x += offset.x;
	bottom.y += offset.y;
}

- (void) horizontallyScale:(CGPoint)l r:(CGPoint)r{

	left.x = l.x;
	right.x = r.x;

	top.x = left.x + (right.x - left.x)/2.0;
	bottom.x = top.x;

}
- (void) verticallyScale:(CGPoint)t b:(CGPoint)b{
	top.y = t.y;
	bottom.y = b.y;

	left.y = top.y + (bottom.y - top.y)/2.0;
	right.y = left.y;
}

- (CGPoint) center{

	float x = right.x - left.x;
	x = left.x + x/2.0;

	float y = bottom.y - top.y;
	y = top.y + y/2.0;

	return CGPointMake(x, y);
}

@end
