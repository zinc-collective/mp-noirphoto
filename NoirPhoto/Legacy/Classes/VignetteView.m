//
//  VignetteView.m
//  OrzQuarz
//
//  Created by mac on 10-11-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VignetteView.h"



#define line_width			3.0
#define check_box_radius    25.0
#define box_offset			15.0
#define box_offset_sel      9.0
#define line_display_ratio	0.5

#define vignette_color      [UIColor colorWithRed:(float)199/255 green:(float)137/255 blue:(float)39/255 alpha:1.0]
#define vignette_color_fade [UIColor clearColor]


@implementation VignetteView
@synthesize delegate;
@synthesize _timer;
@synthesize _vignetteColor;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		self.multipleTouchEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		[self resetEllipseParams];
		
		_actionType = actionNone;
		
		//init default
		_ellipseA_default = frame.size.width/4;
		_ellipseB_default = frame.size.height/4;
		_ellipseAngle_default = 0.0;
		_ellipseCenter_default = CGPointMake(frame.size.width/2, frame.size.height/2);
		
		self._vignetteColor = vignette_color;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code.
	//[self drawVignette];
	[self DrawEllipse];
}




#pragma mark -
#pragma mark in use functions
-(void)resetEllipseParams
{
	//if iphone
	//float frameW = self.frame.size.width;
	//float frameH = self.frame.size.height;
	
	_ellipseA = _ellipseA_default;
	_ellipseB = _ellipseB_default;
	_ellipseAngle = _ellipseAngle_default;
	_ellipseCenter = _ellipseCenter_default;
	//_ellipseCenter = CGPointMake(frameW/2, frameH/2);
	
	[self updateEllipseParams];
	
}
-(CGPoint)transformPoint:(CGPoint)fromPoint
{
	CGFloat sinA = sin(_ellipseAngle);
	CGFloat cosA = cos(_ellipseAngle);
	
	CGPoint resultPoint = CGPointMake(_ellipseCenter.x+cosA*fromPoint.x-sinA*fromPoint.y, _ellipseCenter.y+sinA*fromPoint.x+cosA*fromPoint.y);
	return resultPoint;
}

-(void)updateEllipseParams
{
	_ellipseRect = CGRectMake(-_ellipseA, -_ellipseB, _ellipseA*2, _ellipseB*2);
	
	CGPoint point0 = CGPointMake(_ellipseA, 0);
	CGPoint point1 = CGPointMake(0, -_ellipseB);
	CGPoint point2 = CGPointMake(-_ellipseA, 0);
	CGPoint point3 = CGPointMake(0, _ellipseB);
	
	_point0 = [self transformPoint:point0];
	_point1 = [self transformPoint:point1];
	_point2 = [self transformPoint:point2];
	_point3 = [self transformPoint:point3];
	
	//calcluate checkbox
	_ptCheckBox0 = CGRectMake(_point0.x-check_box_radius, _point0.y-check_box_radius, check_box_radius*2, check_box_radius*2);
	_ptCheckBox1 = CGRectMake(_point1.x-check_box_radius, _point1.y-check_box_radius, check_box_radius*2, check_box_radius*2);
	_ptCheckBox2 = CGRectMake(_point2.x-check_box_radius, _point2.y-check_box_radius, check_box_radius*2, check_box_radius*2);
	_ptCheckBox3 = CGRectMake(_point3.x-check_box_radius, _point3.y-check_box_radius, check_box_radius*2, check_box_radius*2);
}


-(void)DrawEllipse
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	//draw ellipse
	if(_ellipsePath)
	{
		CFRelease(_ellipsePath);
	}
	_ellipsePath = CGPathCreateMutable();
	
	CGAffineTransform ellipseTransform = CGAffineTransformTranslate(CGAffineTransformIdentity,_ellipseCenter.x,_ellipseCenter.y);
	ellipseTransform = CGAffineTransformRotate(ellipseTransform,_ellipseAngle);
	
	[self._vignetteColor set];
	CGContextSetLineWidth(context, line_width);
	CGPathAddEllipseInRect(_ellipsePath, &ellipseTransform, _ellipseRect);
	CGContextAddPath(context, _ellipsePath);
	CGContextStrokePath(context);
	
	
	
	//calculate the point Box
	CGRect useBox0 = CGRectInset(_ptCheckBox0, box_offset_sel, box_offset_sel);
	CGRect useBox1 = CGRectInset(_ptCheckBox1, box_offset_sel, box_offset_sel);
	CGRect useBox2 = CGRectInset(_ptCheckBox2, box_offset_sel, box_offset_sel);
	CGRect useBox3 = CGRectInset(_ptCheckBox3, box_offset_sel, box_offset_sel);
	
	if(!_bInPtBox0)
	{
		useBox0 = CGRectInset(_ptCheckBox0, box_offset, box_offset);
	}
	if(!_bInPtBox1)
	{
		useBox1 = CGRectInset(_ptCheckBox1, box_offset, box_offset);
	}
	if(!_bInPtBox2)
	{
		useBox2 = CGRectInset(_ptCheckBox2, box_offset, box_offset);
	}
	if(!_bInPtBox3)
	{
		useBox3 = CGRectInset(_ptCheckBox3, box_offset, box_offset);
	}
	
	// circle point 0	
	if(_pointPath0){
		CFRelease(_pointPath0);
	}
	_pointPath0 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath0, NULL, useBox0);
	CGContextAddPath(context, _pointPath0);
	CGContextFillPath(context);
	
	// circle point 1
	if(_pointPath1){
		CFRelease(_pointPath1);
	}
	_pointPath1 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath1, NULL, useBox1);
	CGContextAddPath(context, _pointPath1);
	CGContextFillPath(context);	
	
	// circle point 2
	if(_pointPath2){
		CFRelease(_pointPath2);
	}
	_pointPath2 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath2, NULL, useBox2);
	CGContextAddPath(context, _pointPath2);
	CGContextFillPath(context);	
	
	// circle point 3
	if(_pointPath3){
		CFRelease(_pointPath3);
	}
	_pointPath3 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath3, NULL, useBox3);
	CGContextAddPath(context, _pointPath3);
	CGContextFillPath(context);	
	

	
//	//draw center
//	CGMutablePathRef circle = CGPathCreateMutable();
//	CGPathAddEllipseInRect(circle, NULL, CGRectMake(_ellipseCenter.x-5, _ellipseCenter.y-5, 10, 10));
//	CGContextAddPath(context, circle);
//	CGContextFillPath(context);	
//	
//	//darw a line
//	CGPoint lines[2] = {_ellipseCenter, _point0};
//	CGContextStrokeLineSegments(context, lines, 2);
	

	CGContextStrokePath(context);
	
	
	CGContextRestoreGState(context);
	
}






-(void)drawVignette
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[vignette_color set];
	CGContextSetLineWidth(context, line_width);
	
	if(_ellipsePath)
	{
		CFRelease(_ellipsePath);
	}
	_ellipsePath = CGPathCreateMutable();
	
	CGPathAddEllipseInRect(_ellipsePath, NULL, _ellipseRect);
	CGContextAddPath(context, _ellipsePath);
	CGContextStrokePath(context);
	
	


	//calculate the point Box
	CGRect useBox0 = _ptCheckBox0;
	CGRect useBox1 = _ptCheckBox1;
	CGRect useBox2 = _ptCheckBox2;
	CGRect useBox3 = _ptCheckBox3;
	
	
	if(!_bInPtBox0)
	{
		useBox0 = CGRectInset(_ptCheckBox0, box_offset, box_offset);
	}
	if(!_bInPtBox1)
	{
		useBox1 = CGRectInset(_ptCheckBox1, box_offset, box_offset);
	}
	if(!_bInPtBox2)
	{
		useBox2 = CGRectInset(_ptCheckBox2, box_offset, box_offset);
	}
	if(!_bInPtBox3)
	{
		useBox3 = CGRectInset(_ptCheckBox3, box_offset, box_offset);
	}
	
	
	// circle point 0	
	if(_pointPath0){
		CFRelease(_pointPath0);
	}
	_pointPath0 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath0, NULL, useBox0);
	CGContextAddPath(context, _pointPath0);
	CGContextFillPath(context);
	
	// circle point 1
	if(_pointPath1){
		CFRelease(_pointPath1);
	}
	_pointPath1 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath1, NULL, useBox1);
	CGContextAddPath(context, _pointPath1);
	CGContextFillPath(context);	
	
	// circle point 2
	if(_pointPath2){
		CFRelease(_pointPath2);
	}
	_pointPath2 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath2, NULL, useBox2);
	CGContextAddPath(context, _pointPath2);
	CGContextFillPath(context);	
	
	// circle point 3
	if(_pointPath3){
		CFRelease(_pointPath3);
	}
	_pointPath3 = CGPathCreateMutable();
	CGPathAddEllipseInRect(_pointPath3, NULL, useBox3);
	CGContextAddPath(context, _pointPath3);
	CGContextFillPath(context);	
	
	
	CGContextStrokePath(context);
 
}

-(void)checkStateForPoint:(CGPoint)touchPoint
{
	if(CGRectContainsPoint(_ptCheckBox0, touchPoint))
	{
		_bInPtBox0 = YES;
	}
	else if(CGRectContainsPoint(_ptCheckBox1, touchPoint))
	{
		_bInPtBox1 = YES;
	}
	else if(CGRectContainsPoint(_ptCheckBox2, touchPoint))
	{
		_bInPtBox2 = YES;
	}
	else if(CGRectContainsPoint(_ptCheckBox3, touchPoint))
	{
		_bInPtBox3 = YES;
	}
	
	//NSLog(@"selected : (%d, %d, %d, %d)", _bInPtBox0, _bInPtBox1, _bInPtBox2, _bInPtBox3);
	
}
-(BOOL)checkIfInEllipse:(CGPoint)touchPoint
{
	BOOL bIn = NO;
	
	if(CGPathContainsPoint(_ellipsePath, NULL, touchPoint, YES))
	{
		if(!CGRectContainsPoint(_ptCheckBox0, touchPoint) && 
		   !CGRectContainsPoint(_ptCheckBox1, touchPoint) && 
		   !CGRectContainsPoint(_ptCheckBox2, touchPoint) &&
		   !CGRectContainsPoint(_ptCheckBox3, touchPoint) )
		{
			 bIn = YES;
		}
	}
	
	return bIn;
}

-(ActionType)actionTypeForTouchs:(NSArray*)touchs
{
	ActionType acType = actionNone;
	
	if([touchs count] == 1) //check if pan or drag or reset
	{
		UITouch *touch = [touchs objectAtIndex:0];
		
		//只能在内部的时候pan
//		CGPoint touchPoint = [touch locationInView:self];
//		BOOL bInEllipse = [self checkIfInEllipse:touchPoint];
//		if(bInEllipse)
//		{
//			acType = actionPan;
//		}
//		else if(_bInPtBox0 || _bInPtBox1 || _bInPtBox2 || _bInPtBox3) 
//		{
//			acType = actionDrag;
//		}
//		else
//		{
//			if(touch.tapCount == 2)
//			{
//				acType == actionReset;
//			}
//		}
		
		//可以在任何地方pan
		if(_bInPtBox0 || _bInPtBox1 || _bInPtBox2 || _bInPtBox3) 
		{
			acType = actionDrag;
		}
		else if(touch.tapCount == 2)
		{
			acType == actionReset;
		}
		else
		{
			acType = actionPan;
		}


	}
	else if([touchs count] == 2) //check if scall
	{
		if((_bInPtBox0 && _bInPtBox2) || (_bInPtBox1 && _bInPtBox3))
		{
			acType = actionScall;
		}
		else
		{
			acType = actionScallAnyWhere;
		}

	}
	
	//做一个小处理，如果前一个操作是scall现在是pan，那么就返回none
	if(_actionType == actionScall && acType == actionPan)
	{
		acType = actionNone;
	}
	if(_actionType == actionScallAnyWhere && acType == actionPan)
	{
		acType = actionNone;
	}
	
	//NSLog(@"return actionType : %d", acType);
	return acType;
}

//这个地方是绕对角点旋转的drag
-(void)calculateEllipseParamsForDragActionByPoint:(CGPoint)touchPoint
{
	CGPoint point1; //大值
	CGPoint point2; //小值
	BOOL bVetical = NO;

	if(_bInPtBox0)
	{
		point1 = touchPoint;
		point2 = _point2;
		bVetical = NO;
	}
	else if(_bInPtBox1)
	{
		point1 = _point3;
		point2 = touchPoint;
		bVetical = YES;
	}
	else if(_bInPtBox2)
	{
		point1 = _point0;
		point2 = touchPoint;
		bVetical = NO;
	}
	else if(_bInPtBox3)
	{
		point1 = touchPoint;
		point2 = _point1;
		bVetical = YES;
	}
	else
	{
		return;
	}
	
	_ellipseCenter.x = point2.x + (point1.x-point2.x)/2;
	_ellipseCenter.y = point2.y + (point1.y-point2.y)/2;
	
	CGPoint touchLine = CGPointMake(point1.x-point2.x, point1.y-point2.y);
	
	//float kAB = _ellipseB/_ellipseA; //绕对角点旋转，ab需要不等比，暂时注释掉
	CGFloat length = sqrt((point1.x-point2.x)*(point1.x-point2.x)+(point1.y-point2.y)*(point1.y-point2.y));
	if(!bVetical) //0 & 2
	{
		_ellipseA = length/2;
		//_ellipseB = _ellipseA*kAB;//绕对角点旋转，ab需要不等比，暂时注释掉
		_ellipseAngle = atan2(touchLine.y,touchLine.x);
	}
	else          //1 & 3
	{
		_ellipseB = length/2;
		//_ellipseA = _ellipseB/kAB;//绕对角点旋转，ab需要不等比，暂时注释掉
		_ellipseAngle = atan2(touchLine.y, touchLine.x)-M_PI_2;
	}
	
}

/*
//这个地方是绕中心点旋转的drag
-(void)calculateEllipseParamsForDragActionByPoint:(CGPoint)touchPoint
{
	CGPoint point1; //大值
	CGPoint point2; //小值
	BOOL bVetical = NO;
	
	if(_bInPtBox0)
	{
		point1 = touchPoint;
		point2 = _ellipseCenter;
		bVetical = NO;
	}
	else if(_bInPtBox1)
	{
		point1 = _ellipseCenter;
		point2 = touchPoint;
		bVetical = YES;
	}
	else if(_bInPtBox2)
	{
		point1 = _ellipseCenter;
		point2 = touchPoint;
		bVetical = NO;
	}
	else if(_bInPtBox3)
	{
		point1 = touchPoint;
		point2 = _ellipseCenter;
		bVetical = YES;
	}
	else
	{
		return;
	}


	CGPoint touchLine = CGPointMake(point1.x-point2.x, point1.y-point2.y);
	
	CGFloat length = sqrt((point1.x-point2.x)*(point1.x-point2.x)+(point1.y-point2.y)*(point1.y-point2.y));
	if(!bVetical) //0 & 2
	{
		_ellipseA = length;
		_ellipseAngle = atan2(touchLine.y,touchLine.x);
	}
	else          //1 & 3
	{
		_ellipseB = length;
		_ellipseAngle = atan2(touchLine.y, touchLine.x)-M_PI_2;
	}
	
}
*/

-(void)setVignettePramsForOffsetX:(float)offsetX offsetY:(float)offsetY
{
	_ellipseCenter.x += offsetX;
	_ellipseCenter.y += offsetY;
}
-(void)setVignetteParamsForPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2
{
	//计算原始angle
	CGPoint beginTouchLine = CGPointMake(_scallAnyBeginPoint1.x-_scallAnyBeginPoint2.x, _scallAnyBeginPoint1.y-_scallAnyBeginPoint2.y);
	double orignAngle = atan2(beginTouchLine.y,beginTouchLine.x);
	CGFloat beginLength = sqrt((_scallAnyBeginPoint1.x-_scallAnyBeginPoint2.x)*(_scallAnyBeginPoint1.x-_scallAnyBeginPoint2.x)+(_scallAnyBeginPoint1.y-_scallAnyBeginPoint2.y)*(_scallAnyBeginPoint1.y-_scallAnyBeginPoint2.y));
	
	//现在的angle
	CGPoint touchLine = CGPointMake(point1.x-point2.x, point1.y-point2.y);
	CGFloat length = sqrt((point1.x-point2.x)*(point1.x-point2.x)+(point1.y-point2.y)*(point1.y-point2.y));
	double nowAngle = atan2(touchLine.y,touchLine.x);
	
	
	//计算角度差
	double angleOffset = nowAngle - orignAngle;
	_ellipseAngle += angleOffset;
	
	//计算长宽比例
	float kLength = length/beginLength;
	_ellipseA = _ellipseA*kLength;
	_ellipseB = _ellipseB*kLength;
	
	
	//save to temp
	_scallAnyAngleTemp = angleOffset;
	_scallAnyKLenthTemp = kLength;
	
}

-(void)returnVignetteAction:(BOOL)isFinal bChangePresetState:(BOOL)bChange
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(vignetteViewDidChange:isFinal:bChangePresetState:)])
	{
		Parameter *parameter = [self paramsForVignette];
		[self.delegate vignetteViewDidChange:parameter isFinal:isFinal bChangePresetState:bChange];
	}
}





#pragma mark -
#pragma mark touches functions
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{
	//check if show
	NSLog(@"begin");
	[self stopTimer];
	[self showVignetteView:YES];
	
	
	
	NSSet *allTouches = [event allTouches];
	//NSLog(@"touch count: %d", [allTouches count]);
	
	if([allTouches count] >= 3) return;
	

	//确定选中状态
	NSArray *touchs = [allTouches allObjects];
    for(UITouch *touch in touchs)
	{
		CGPoint touchPoint = [touch locationInView:self];
		[self checkStateForPoint:touchPoint];
	}
	
	//确定动作类型
	_actionType = [self actionTypeForTouchs:touchs];
	
	
	//如果是pan，那么获取begin point
	if(_actionType == actionPan)
	{
		if([allTouches count] == 1)
		{
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			CGPoint touchPoint = [touch locationInView:self];
			_panTouchBeginPoint = touchPoint;
		}
	}
	
	//如果是scallanywhere 那么获取_scallAnyBeginPoint1 & _scallAnyBeginPoint2
	if(_actionType == actionScallAnyWhere)
	{
		if([allTouches count] == 2)
		{
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			_scallAnyBeginPoint1 = [touch1 locationInView:self];
			_scallAnyBeginPoint2 = [touch2 locationInView:self];
		}
	}
	
	
	[self setNeedsDisplay];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event 
{	
	//这个地方需要先加入pan功能
	NSSet *allTouches = [event allTouches];
	
	if([allTouches count] >= 3) return;
	
	if([allTouches count] == 1)
	{
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		CGPoint touchPoint = [touch locationInView:self];
		
		if(_actionType == actionPan)
		{
			//NSLog(@"pan move");
			_offsetX = touchPoint.x - _panTouchBeginPoint.x;
			_offsetY = touchPoint.y - _panTouchBeginPoint.y;
			
			[self setVignettePramsForOffsetX:_offsetX offsetY:_offsetY];
			_panTouchBeginPoint = touchPoint;
		}
		else if(_actionType == actionDrag)
		{
			[self calculateEllipseParamsForDragActionByPoint:touchPoint];
		}
	}
	else if([allTouches count] == 2)
	{
		if(_actionType == actionScall)
		{
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			CGPoint point1 = [touch1 locationInView:self];
			CGPoint point2 = [touch2 locationInView:self];
			
			CGPoint touchLine = CGPointMake(point1.x-point2.x, point1.y-point2.y);
			if(CGRectContainsPoint(_ptCheckBox2, point1) || CGRectContainsPoint(_ptCheckBox1, point1))
			{
				touchLine.x = -touchLine.x;
				touchLine.y = -touchLine.y;
			}
			
	
			CGFloat length = sqrt((point1.x-point2.x)*(point1.x-point2.x)+(point1.y-point2.y)*(point1.y-point2.y));
			
			/*//这个地方是做两个手指 不等比 带旋转
			if(_bInPtBox0 && _bInPtBox2)
			{
				_ellipseA = length/2;
				_ellipseAngle = atan2(touchLine.y,touchLine.x);
			}
			else
			{
				_ellipseB = length/2;
				_ellipseAngle = atan2(touchLine.y, touchLine.x)-M_PI_2;
			}
			*/
			
			/*//这个地方是做两个手指 等比 不带旋转
			float kAB = _ellipseB/_ellipseA;
			if(_bInPtBox0 && _bInPtBox2)
			{
				_ellipseA = length/2;
				_ellipseB = _ellipseA*kAB;
			}
			else
			{
				_ellipseB = length/2;
				_ellipseA = _ellipseB/kAB;
			}
			*/
			
			//这个地方是做两个手指 等比 带旋转
			float kAB = _ellipseB/_ellipseA;
			if(_bInPtBox0 && _bInPtBox2)
			{
				_ellipseA = length/2;
				_ellipseB = _ellipseA*kAB;
				_ellipseAngle = atan2(touchLine.y,touchLine.x);
			}
			else
			{
				_ellipseB = length/2;
				_ellipseA = _ellipseB/kAB;
				_ellipseAngle = atan2(touchLine.y, touchLine.x)-M_PI_2;
			}
		}
		else if(_actionType == actionScallAnyWhere)
		{
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			CGPoint point1 = [touch1 locationInView:self];
			CGPoint point2 = [touch2 locationInView:self];
			
			[self setVignetteParamsForPoint1:point1 andPoint2:point2];
			
			_scallAnyBeginPoint1 = point1;
			_scallAnyBeginPoint2 = point2;
		}
		
	}
	
	[self updateEllipseParams];
	
/*	
	//检查pan的时候，是否所有的点都移动到了屏幕外面，如果是，那么停止pan
	if(_actionType == actionPan)
	{
		CGRect frameRect = CGRectMake(10.0, 10.0, self.frame.size.width-20.0, self.frame.size.height-20.0);
		if(!CGRectContainsPoint(frameRect, _point0) && 
		   !CGRectContainsPoint(frameRect, _point1) && 
		   !CGRectContainsPoint(frameRect, _point2) && 
		   !CGRectContainsPoint(frameRect, _point3))
		{
			_actionType = actionNone;
			[self setVignettePramsForOffsetX:-_offsetX offsetY:-_offsetY];
			[self updateEllipseParams];
			return;
		}
	}
	
	
	//检查scallanywhere的时候，是否所有的点都移动到了屏幕外面，如果是，那么停止scall
	if(_actionType == actionScallAnyWhere)
	{
		CGRect frameRect = CGRectMake(10.0, 10.0, self.frame.size.width-20.0, self.frame.size.height-20.0);
		if(!CGRectContainsPoint(frameRect, _point0) && 
		   !CGRectContainsPoint(frameRect, _point1) && 
		   !CGRectContainsPoint(frameRect, _point2) && 
		   !CGRectContainsPoint(frameRect, _point3))
		{
			_actionType = actionNone;
			
			//计算角度差
			_ellipseAngle -= _scallAnyAngleTemp;
			
			//计算长宽比例
			_ellipseA = _ellipseA/_scallAnyKLenthTemp;
			_ellipseB = _ellipseB/_scallAnyKLenthTemp;
			
			[self updateEllipseParams];
			return;
		}
	}
*/	

	[self setNeedsDisplay];
	[self returnVignetteAction:NO bChangePresetState:YES];
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event 
{
	NSInteger eventCount = [[event allTouches] count];
	NSInteger touchCount = [touches count];
	
//	NSLog(@"---event count: %d", eventCount);
//	NSLog(@"---touch count: %d", touchCount);
	
	if(eventCount >= 3) return;
	
	_bInPtBox0 = NO;
	_bInPtBox1 = NO;
	_bInPtBox2 = NO;
	_bInPtBox3 = NO;
	
	
	//处理两个手指抬起一个还剩一个的情况
	if(touchCount == 1 && eventCount == 2)
	{
		//leave touch
		UITouch *leaveTouch = [[touches allObjects] objectAtIndex:0];
		CGPoint leavePoint = [leaveTouch locationInView:self];

		//got remain touch
		CGPoint remainPoint;
		UITouch *remainTouch;
		NSArray *eventTouchs = [[event allTouches] allObjects];
		for(UITouch *touch in eventTouchs)
		{
			CGPoint eventPoint = [touch locationInView:self];
			if(eventPoint.x != leavePoint.x && eventPoint.y != leavePoint.y)
			{
				remainPoint = eventPoint;
				remainTouch = touch;
				break;
			}
		}
		
		[self checkStateForPoint:remainPoint];
		
		//重新计算action type
		if(_actionType != actionNone)
		{
			NSArray *remain = [NSArray arrayWithObject:remainTouch];
			_actionType = [self actionTypeForTouchs:remain];
		}
		
		[self setNeedsDisplay];
		return;
	}
	
	
	//处理双击的情况
	NSSet *allTouches = [event allTouches];
	if([allTouches count] == 1)
	{
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		if(touch.tapCount == 2)
		{
			//双点击
			//重新计算action type
			NSArray *tapTouchs = [NSArray arrayWithObject:touch];
			_actionType = [self actionTypeForTouchs:tapTouchs];
			
			//reset ellipse params
			[self resetEllipseParams];
			
			self._vignetteColor = vignette_color;
		}
	}
	
	
	[self setNeedsDisplay];
	[self returnVignetteAction:YES bChangePresetState:YES];
	
	
	//handle the show state
	[self startTimer];
	
}

-(void)showVignetteView:(BOOL)bShow
{
	if(bShow)
	{
		//if(self.alpha == 1.0) return;
		self._vignetteColor = vignette_color;
		[self setNeedsDisplay];
		
		[UIView beginAnimations:@"show animation" context:nil]; 
		[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 
		[UIView setAnimationDuration:0.2f];
		
		self.alpha = 1.0;
		
		[UIView commitAnimations];
		
	}
	else
	{
		//if(self.alpha == 0.02) return;
		[UIView beginAnimations:@"hide animation" context:nil]; 
		
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(vignetteViewDidHide)];
		
		[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 
		[UIView setAnimationDuration:0.2f];
		
		self.alpha = 0.02;
		
		[UIView commitAnimations];
		
	}
}

-(void)vignetteViewDidHide
{
	self._vignetteColor = vignette_color_fade;
	[self setNeedsDisplay];
}






#pragma mark -
#pragma mark out use functions
-(void)setVignetteForParam:(Parameter*)parameter photoRect:(CGRect)photoRect
{
	float cx = parameter.ellipseCenterX;  //比例尺寸 0-1 .相对于照片的比例
	float cy = -parameter.ellipseCenterY;
	float a  = parameter.ellipseA * line_display_ratio;
	float b  = parameter.ellipseB * line_display_ratio;
	float an = parameter.ellipseAngle;
	
	float px = photoRect.origin.x;
	float py = photoRect.origin.y;
	float pw = photoRect.size.width;
	float ph = photoRect.size.height;
	
	//if iphone
	//未完成
	//目前只计算了横竖状态的，旋转状态的，还没做
	
	float elipsCx = px+pw/2+(pw/2)*cx;  //椭圆相对于绝对坐标系的中心点坐标
	float elipsCy = py+ph/2+(ph/2)*cy;
	
	_ellipseCenter = CGPointMake(elipsCx, elipsCy);
	_ellipseAngle = -an;
	_ellipseA = (pw/2)*fabs(a);			//椭圆相对于绝对坐标系的a,b值
	_ellipseB = (ph/2)*fabs(b);
	
	
	//save to default
	_ellipseA_default = pw/4;
	_ellipseB_default = ph/4;
	
//	_ellipseA_default = _ellipseA;
//	_ellipseB_default = _ellipseB;
//	_ellipseAngle_default = _ellipseAngle;
//	_ellipseCenter_default = _ellipseCenter;
	
	
	_photoRect = photoRect;
	
	
	[self updateEllipseParams];
	[self setNeedsDisplay];
	[self returnVignetteAction:YES bChangePresetState:NO];
	
	
	[self stopTimer];
	[self showVignetteView:YES];
	[self startTimer];
}

-(Parameter*)paramsForVignette
{
	//TO DO: add convert function
	float px = _photoRect.origin.x;
	float py = _photoRect.origin.y;
	float pw = _photoRect.size.width;
	float ph = _photoRect.size.height;
	
    Parameter *param = [[Parameter alloc] init];
	param.ellipseAngle = -_ellipseAngle;
	param.ellipseA = _ellipseA/((pw/2)*line_display_ratio);
	param.ellipseB = _ellipseB/((ph/2)*line_display_ratio);
	param.ellipseCenterX = (_ellipseCenter.x-px-(pw/2))/(pw/2);
	param.ellipseCenterY = -(_ellipseCenter.y-py-(ph/2))/(ph/2);
	
	return param;
}




#pragma mark -
#pragma mark timer functions
-(void)startTimer
{
	self._timer =  [NSTimer scheduledTimerWithTimeInterval:2
													target:self 
												  selector:@selector(timerFireMethod:) 
												  userInfo:nil 
												   repeats:NO];
}
-(void)stopTimer
{
	if(self._timer && [self._timer isValid])
	{
		[self._timer invalidate];
	}	
}
-(void)FireTheTimerMethod
{
	[self._timer fire];
}
-(void)timerFireMethod:(NSTimer*)theTimer
{
	[self stopTimer];
	[self showVignetteView:NO];
}



@end
