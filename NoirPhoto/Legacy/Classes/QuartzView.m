#import "QuartzView.h"

@implementation UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj
{
    if ((__bridge void *)self < (__bridge void *)obj) {
        return NSOrderedAscending;
    } else if ((__bridge void *)self == (__bridge void *)obj) {
        return NSOrderedSame;
    } else {
        return NSOrderedDescending;
    }
}

@end


CGRect eRect;
CGRect eCenter;
CGPoint vertexs[4];
int touchVertex;
int mirrorVertex;

CGPoint rotateCenter;
CGFloat eRotate;

CGFloat scaleX;
CGFloat scaleY;

@implementation QuartzView

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor grayColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		
		self.multipleTouchEnabled = YES;
		
		scaleX = 1.0;
		scaleY = 1.0;
		eRotate = 0.0;
		rotateCenter = CGPointMake(0, 0);
		
		touchVertex = -1;
		mirrorVertex = -1;
		
		eRect = CGRectMake(90, 30, 140, 180);
		vertexs[0] = CGPointMake(eRect.origin.x, eRect.origin.y + eRect.size.height/2);
		vertexs[1] = CGPointMake(eRect.origin.x + eRect.size.width/2, eRect.origin.y);
		vertexs[2] = CGPointMake(eRect.origin.x + eRect.size.width,	eRect.origin.y + eRect.size.height/2);
		vertexs[3] = CGPointMake(eRect.origin.x + eRect.size.width/2, eRect.origin.y + eRect.size.height);
	}
	return self;
}


void caculatePosition(CGPoint p0, CGPoint p1, CGPoint p2)
{
	//printf("p1.y=%.2f\t\tp0.y=%.2f\n", p1.y , p0.y);
	
	float p0p1x = p1.x - p0.x;
	float p0p1y = p1.y - p0.y;
	
	//printf("p0p1x=%.2f\t\tp0p1y=%.2f\n", p0p1x , p0p1y);
	
	float p0p2x = p2.x - p0.x;
	float p0p2y = p2.y - p0.y;
	
	float p0p1m = sqrt(p0p1x * p0p1x + p0p1y * p0p1y);
	float p0p2m = sqrt(p0p2x * p0p2x + p0p2y * p0p2y);
	
	//printf("p0p1m=%.2f\t\tp0p2m=%.2f\n", p0p1m , p0p2m);
	
	float cosa = (p0p1x * p0p2x + p0p1y * p0p2y) / (p0p1m * p0p2m);
	//printf("cosa=%.2f\n", cosa);
	
	eRotate = acos( cosa );
	
	// rotate direction by cross product
	if ((p0p2x * p0p1y - p0p1x * p0p2y) > 0)
	{
		eRotate = - eRotate;
	}
	
	if (touchVertex%2 == 0)
	{
		
		scaleX = scaleY = p0p2m/140.0f;
	}
	else
	{
		scaleX = scaleY = p0p2m/180.0f;
	}
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
	NSInteger count = [sortedTouches count];
	
	if(count == 1)
	{
		CGPoint current = [[sortedTouches objectAtIndex:0] locationInView:self];
		
		for (int i = 0; i < 4; i++)
		{
			float disX = current.x - vertexs[i].x;
			float disY = current.y - vertexs[i].y;
			
			float dis = sqrt(disX * disX + disY * disY);
			
			if(dis < 20)
			{
				touchVertex = i;
				break;
			}
		}
		
		//printf("touchVertex=%i\n", touchVertex);
	}
	
	[self setNeedsDisplay];
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
	//NSInteger count = [sortedTouches count];

	if (touchVertex >= 0)
	{
		UITouch *touch = [sortedTouches objectAtIndex:0];
		//CGPoint previous = [touch previousLocationInView:self];
		CGPoint current = [touch locationInView:self];
		
		mirrorVertex = (touchVertex + 2) % 4;
		rotateCenter.x = vertexs[mirrorVertex].x;
		rotateCenter.y = vertexs[mirrorVertex].y;
		
		//printf("current.x=%.2f, current.y=%.2f\n", current.x, current.y);
		//printf("rotateCenter.x=%.2f, rotateCenter.y=%.2f\n", rotateCenter.x, rotateCenter.y);
		
		caculatePosition(vertexs[mirrorVertex], vertexs[touchVertex], current);
		
//		if (touchVertex %2 == 0)
//		{
//			scaleX = scaleY = m / 140;
//		}
//		else
//		{
//			scaleX = scaleY = m / 180;
//		}
		
		//printf("\neRotate=%.2f, scaleX=%.2f, scaleY=%.2f, m=%.2f", eRotate, scaleX, scaleY, m);
	}
	
	
	//rotate = calculateRotate(vertexs[2], vertexs[0]);
	
	
	
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchVertex = -1;
	mirrorVertex = -1;
	[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchVertex = -1;
	mirrorVertex = -1;
	[self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
	//printf("scale=%.2f\teRotate=%.2f\tcenter.x=%.2f\tcenter.y=%.2f\n", scaleX, eRotate, rotateCenter.x, rotateCenter.y);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGAffineTransform toOrigin  = CGAffineTransformMakeTranslation(-rotateCenter.x, -rotateCenter.y);
	CGAffineTransform andScale = CGAffineTransformConcat(toOrigin, CGAffineTransformMakeScale(scaleX, scaleY));
	CGAffineTransform andRotate = CGAffineTransformConcat(andScale, CGAffineTransformMakeRotation(eRotate));
	CGAffineTransform resetPos  = CGAffineTransformConcat(andRotate, CGAffineTransformMakeTranslation(rotateCenter.x, rotateCenter.y));
	
	CGContextConcatCTM(context, resetPos);
	
	[[UIColor yellowColor] set];
	CGContextSetLineWidth(context, 2.0);
	
	if(ellipsePath)
	{
		CFRelease(ellipsePath);
	}
	
	ellipsePath = CGPathCreateMutable();
	
	CGPathAddEllipseInRect(ellipsePath, NULL, eRect);
	CGContextAddPath(context, ellipsePath);
	
	CGContextStrokePath(context);
	
	for (int i = 0; i < 4; i++)
	{
		if (controlPointPath[i])
		{
			CFRelease(controlPointPath[i]);
		}
		
		int offset = 10;
		if (i == touchVertex)
		{
			offset = 20;
		}
		controlPointPath[i] = CGPathCreateMutable();
		
		CGRect pointBox = CGRectMake(vertexs[i].x-offset, vertexs[i].y-offset, offset*2, offset*2);
		
		CGPathAddEllipseInRect(controlPointPath[i], NULL, pointBox);
		CGContextAddPath(context, controlPointPath[i]);
		CGContextFillPath(context);
	}
}

@end