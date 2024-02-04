

#import "EllipseView.h"

@implementation EllipseView

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		
		self.userInteractionEnabled = NO;
						
		//self.transform = trans;
		
		bottomPointPath = NULL;
		rightPointPath = NULL;
		leftPointPath = NULL;
		topPointPath = NULL;
		ellipsePath = NULL;
		
		offset_normal = -10.0f;
		offset_select = -20.0f;
		
		vertexs = [[NSMutableDictionary alloc] init];
		
		//self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/6.0);
		
		
		_offset = 20.0;
		
		
	}
	return self;
}

- (void) clearVertexRemembered{
	[vertexs removeAllObjects];
}

- (CGRect) leftVertexBox{
	return CGRectMake(_offset, self.frame.size.height/2.0, 0.0f, 0.0f);
}

- (CGRect) rightVertexBox{
	return CGRectMake(self.frame.size.width-_offset, self.frame.size.height/2.0, 0.0f, 0.0f);
}
- (CGRect) topVertexBox{
	return CGRectMake(self.frame.size.width/2.0, _offset, 0.0f, 0.0f);
}
- (CGRect) bottomVertexBox{
	return CGRectMake(self.frame.size.width/2.0, self.frame.size.height-_offset, 0.0f, 0.0f);
}

- (CGPoint) leftVertex{
	return CGPointMake(_offset, self.frame.size.height/2.0);
}
- (CGPoint) rightVertex{
	return CGPointMake(self.frame.size.width-_offset, self.frame.size.height/2.0);
}
- (CGPoint) topVertex{
	return CGPointMake(self.frame.size.width/2.0, _offset);
}
- (CGPoint) bottomVertex{
	return CGPointMake(self.frame.size.width/2.0, self.frame.size.height-_offset);
}



- (int) hitTestEllipseVertex:(CGPoint)pt{
	
	if(CGRectContainsPoint(CGRectInset([self leftVertexBox], -_offset, -_offset), pt)){
		[vertexs setObject:@"1" forKey:@"left"];
		return VertexLeft;
	}
	if(CGRectContainsPoint(CGRectInset([self rightVertexBox], -_offset, -_offset), pt)){		
		[vertexs setObject:@"1" forKey:@"right"];
		return VertexRight;
	}
	if(CGRectContainsPoint(CGRectInset([self topVertexBox], -_offset, -_offset), pt)){	
		[vertexs setObject:@"1" forKey:@"top"];
		return VertexTop;
	}
	if(CGRectContainsPoint(CGRectInset([self bottomVertexBox], -_offset, -_offset), pt)){	
		[vertexs setObject:@"1" forKey:@"bottom"];
		return VertexBottom;
	}
	
	if(ellipsePath && CGPathContainsPoint(ellipsePath, NULL, pt, YES)){
		return VertexInset;
	}
	
	return VertexNone;
}

- (int) hitTestBox:(CGPoint)pt{
	
	if(CGRectContainsPoint(CGRectInset([self leftVertexBox], -_offset, -_offset), pt)){
		[vertexs setObject:@"1" forKey:@"left"];
		return -1;
	}
	if(CGRectContainsPoint(CGRectInset([self rightVertexBox], -_offset, -_offset), pt)){
		[vertexs setObject:@"1" forKey:@"right"];
		return 1;
	}
	if(CGRectContainsPoint(CGRectInset([self topVertexBox], -_offset, -_offset), pt)){
		[vertexs setObject:@"1" forKey:@"top"];
		return -2;
	}
	if(CGRectContainsPoint(CGRectInset([self bottomVertexBox], -_offset, -_offset), pt)){
		[vertexs setObject:@"1" forKey:@"bottom"];
		return 2;
	}
	return 0;
}

- (int) dragTestEllipseVertex:(CGPoint)pt pt2:(CGPoint)pt2{
	
	int pt1InBox = [self hitTestBox:pt];
	int pt2InBox = [self hitTestBox:pt2];
	
	float dragFlagDirection = 0;
	
	if(pt1InBox && 0 == (pt1InBox+pt2InBox)){
		
		if(abs(pt1InBox) == 1){
			
			if(pt1InBox < 0){
				dragFlagDirection = 112;
			}
			else{
				dragFlagDirection = 121;
			}
		}
		else{
			if(pt1InBox < 0){
				dragFlagDirection = -112;
			}
			else{
				dragFlagDirection = -121;
			}
		}
		
		 
	}
	else{
		[vertexs removeAllObjects];
	}
	
	return dragFlagDirection;
	
}

-(void)drawRect:(CGRect)rect
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor yellowColor] set];
	CGContextSetLineWidth(context, 2.0);
	
	if(ellipsePath){
		CFRelease(ellipsePath);
	}
	ellipsePath = CGPathCreateMutable();
	
	CGPathAddEllipseInRect(ellipsePath, NULL, CGRectMake(_offset, _offset, self.frame.size.width-_offset*2,self.frame.size.height-_offset*2));
	CGContextAddPath(context, ellipsePath);

	
	CGContextStrokePath(context);
	
	//NSLog(@"%f-%f-%f-%f", _offset, _offset, self.frame.size.width-_offset*2,self.frame.size.height-_offset*2);
	
	
	float offset = offset_normal;
	if([vertexs objectForKey:@"top"]){
		offset = offset_select;
	}
	CGRect topbox = CGRectInset([self topVertexBox], offset, offset);
	
	offset = offset_normal;
	if([vertexs objectForKey:@"bottom"]){
		offset = offset_select;
	}
	CGRect bottombox = CGRectInset([self bottomVertexBox], offset, offset);
	
	offset = offset_normal;
	if([vertexs objectForKey:@"left"]){
		offset = offset_select;
	}
	CGRect leftbox = CGRectInset([self leftVertexBox], offset, offset);
	
	offset = offset_normal;
	if([vertexs objectForKey:@"right"]){
		offset = offset_select;
	}
	CGRect rightbox = CGRectInset([self rightVertexBox], offset, offset);
	

	// circle point 1	
	if(topPointPath){
		CFRelease(topPointPath);
	}
	topPointPath = CGPathCreateMutable();
	CGPathAddEllipseInRect(topPointPath, NULL, topbox);
	CGContextAddPath(context, topPointPath);
	CGContextFillPath(context);
	
	// circle point 2
	if(bottomPointPath){
		CFRelease(bottomPointPath);
	}
	bottomPointPath = CGPathCreateMutable();
	CGPathAddEllipseInRect(bottomPointPath, NULL, bottombox);
	CGContextAddPath(context, bottomPointPath);
	CGContextFillPath(context);	
	
	// circle point 3
	if(leftPointPath){
		CFRelease(leftPointPath);
	}
	leftPointPath = CGPathCreateMutable();
	CGPathAddEllipseInRect(leftPointPath, NULL, leftbox);
	CGContextAddPath(context, leftPointPath);
	CGContextFillPath(context);	
	
	// circle point 4
	if(rightPointPath){
		CFRelease(rightPointPath);
	}
	rightPointPath = CGPathCreateMutable();
	CGPathAddEllipseInRect(rightPointPath, NULL, rightbox);
	CGContextAddPath(context, rightPointPath);
	CGContextFillPath(context);	
	
	CGContextStrokePath(context);
	
}

@end