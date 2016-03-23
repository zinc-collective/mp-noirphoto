

#import <UIKit/UIKit.h>

@interface UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj;

@end

@interface QuartzView : UIView
{
	CGMutablePathRef ellipsePath;
	CGMutablePathRef controlPointPath[4];
}

@end