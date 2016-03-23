

#import <UIKit/UIKit.h>

typedef enum VERTEX{
	VertexNone = 0,
	VertexLeft,
	VertexRight,
	VertexTop,
	VertexBottom,
	VertexInset
}Vertex;

@interface EllipseView : UIView
{
	
	CGMutablePathRef bottomPointPath;
	CGMutablePathRef rightPointPath;
	CGMutablePathRef leftPointPath;
	CGMutablePathRef topPointPath;
	
	CGMutablePathRef ellipsePath;
	
	float offset_normal;
	float offset_select;
	
	NSMutableDictionary* vertexs;
	
	float _offset;

}

- (void) clearVertexRemembered;

- (CGRect) leftVertexBox;
- (CGRect) rightVertexBox;
- (CGRect) topVertexBox;
- (CGRect) bottomVertexBox;

- (CGPoint) bottomVertex;
- (CGPoint) topVertex;
- (CGPoint) leftVertex;
- (CGPoint) rightVertex;

- (int) hitTestEllipseVertex:(CGPoint)pt;

- (int) dragTestEllipseVertex:(CGPoint)pt pt2:(CGPoint)pt2;

- (int) hitTestBox:(CGPoint)pt;


@end