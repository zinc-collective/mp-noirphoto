//
//  SplashCtrlor.m
//
//  Created by mac on 10-11-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashCtrlor.h"
#import "SplashInfoCtrlor.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "DeviceDetect.h"

#define save_origin_photo_path		@"/Documents/origin_photo.jpg"


#define photo_limit_iPhone3_3GS     2048.0
#define photo_limit_iPhone4         2592.0
#define photo_limit_iPad            2048.0

#define IPHONE5_HEIGHT_DIFFERENCE 88 //568-480

@implementation SplashCtrlor
@synthesize delegate;
@synthesize albumBtn;
@synthesize infoBtn;
@synthesize backView;
@synthesize bCanRotate;


#pragma mark -
#pragma mark system functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		bCanRotate = NO;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        helpBtn = [[UIButton alloc]initWithFrame:CGRectMake(690, 950, 85, 85)];
        [self.view addSubview:helpBtn];
        [helpBtn  setImage:[UIImage imageNamed:@"btn_info-iPad.png"] forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    infoBtn.hidden = YES;
    
    return self;
}

int isRotate = 0;

- (void)viewDidLoad
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		//init picker
		_imagePicker = [[UIImagePickerController alloc] init];
		_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		_imagePicker.delegate = self;
		
		_imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_imagePicker];
		_imagePickerPopover.delegate = self;
		_imagePickerPopover.popoverContentSize = CGSizeMake(320, 480);

	}
	
	//add saving mask
	_maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
	_maskView.backgroundColor = [UIColor blackColor];
	_maskView.alpha = 0.5;
	_maskView.hidden = YES;
	[self.view addSubview:_maskView];
	
	//add saving spinner
	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	_spinner.frame = CGRectMake((self.view.frame.size.width-25.0)/2, (self.view.frame.size.height-25.0)/2, 25.0, 25.0);
	_spinner.hidden = YES;
	[_spinner stopAnimating];
	[self.view addSubview:_spinner];
    
    //bret button fix-up for the 4 inch display
    if (IS_IPHONE_5)
    {
        CGRect frame = albumBtn.frame;
        frame.origin.y += IPHONE5_HEIGHT_DIFFERENCE;
        albumBtn.frame = frame;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{

	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
        _curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		
		if(_curOrientation == UIInterfaceOrientationPortrait || _curOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			backView.image = [UIImage imageNamed:@"splash-iPad.png"];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load-iPad.png"] forState:UIControlStateNormal];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateHighlighted];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateDisabled];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateSelected];
			
			_maskView.frame = CGRectMake(0, 0, 768, 1024);
			_spinner.frame = CGRectMake((768-25.0)/2, (1024-25.0)/2, 25.0, 25.0);
		}
		else
		{
			backView.image = [UIImage imageNamed:@"splash-iPad-Landscape.png"];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_Landscape-iPad.png"] forState:UIControlStateNormal];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateHighlighted];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateDisabled];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateSelected];
			
			_maskView.frame = CGRectMake(0, 0, 1024, 768);
			_spinner.frame = CGRectMake((1024-25.0)/2, (768-25.0)/2, 25.0, 25.0);
		}
	}
}
- (void)viewDidAppear:(BOOL)animated
{
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{		
		//-----
		if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			backView.image = [UIImage imageNamed:@"splash-iPad.png"];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load-iPad.png"] forState:UIControlStateNormal];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateHighlighted];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateDisabled];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateSelected];
			
			_maskView.frame = CGRectMake(0, 0, 768, 1024);
			_spinner.frame = CGRectMake((768-25.0)/2, (1024-25.0)/2, 25.0, 25.0);
		}
		else
		{
			backView.image = [UIImage imageNamed:@"splash-iPad-Landscape.png"];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_Landscape-iPad.png"] forState:UIControlStateNormal];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateHighlighted];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateDisabled];
			[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateSelected];
			
			_maskView.frame = CGRectMake(0, 0, 1024, 768);
			_spinner.frame = CGRectMake((1024-25.0)/2, (768-25.0)/2, 25.0, 25.0);
		}
        
        //helpBtn.frame = CGRectMake(200, 200, 200, 200);
		//-----
        
        if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            helpBtn.frame = CGRectMake(690, 950, 85, 85);
        } else {
            helpBtn.frame = CGRectMake(950, 0, 85, 85);
        }
		
		if(self.albumBtn != nil && self.albumBtn.enabled == NO)
		{
			_curOrientation = toInterfaceOrientation;
			[_imagePickerPopover dismissPopoverAnimated:NO];
		}
	}
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		if(self.albumBtn != nil && self.albumBtn.enabled == NO)
		{
			[self albumAction:nil];
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		_curOrientation = toInterfaceOrientation;
		return self.bCanRotate;
	}
	else
	{
		return NO;
	}
}
//bret
- (BOOL)shouldAutorotate
{
	return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}



#pragma mark -
#pragma mark in use functions
-(IBAction)infoAction:(id)sender
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		//push to splash info page
		SplashInfoCtrlor *splashInfo = [[SplashInfoCtrlor alloc] initWithNibName:@"SplashInfo-iPad" bundle:nil];
		[self.navigationController pushViewController:splashInfo animated:YES];
	}
	else
	{
		if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(splashInfoActioned)])
		{
			[self.delegate splashInfoActioned];
		}
	}
}
-(IBAction)albumAction:(id)sender
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		CGRect popFrom = CGRectMake(645, 900, 50, 50);
		if(_curOrientation == UIInterfaceOrientationLandscapeLeft || _curOrientation == UIInterfaceOrientationLandscapeRight)
		{
			popFrom = CGRectMake(905, 80, 50, 50);
		}
		
		//show popover imagepicker
		[_imagePickerPopover presentPopoverFromRect:popFrom
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
		
		self.albumBtn.enabled = NO;
	}
	else
	{
		if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(splashAlbumActioned:)])
		{
			[self.delegate splashAlbumActioned:sender];
		}
	}
}
-(void)saveOriginPhoto:(UIImage*)image
{
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	NSString *filePath = [NSHomeDirectory() stringByAppendingString:save_origin_photo_path];
	[imageData writeToFile:filePath atomically:YES];
}
-(void)startWait
{
	_maskView.hidden = NO;
	_spinner.hidden = NO;
	[_spinner startAnimating];
}
-(void)stopWait
{
	[_spinner stopAnimating];
	_spinner.hidden = YES;
	_maskView.hidden = YES;
}

/*
-(void)changeForAccerateXY:(AccelerXYState)xyState
{
	
	CGAffineTransform transfm;
	if(xyState == accelerXYStatePortrait || xyState == accelerXYStatePortraitUpsideDown)
	{
		backView.frame = CGRectMake(0, 0, 768, 1024);
		albumBtn.frame = CGRectMake(0, 0, 768, 1024);
		
		backView.image = [UIImage imageNamed:@"splash-iPad.png"];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load-iPad.png"] forState:UIControlStateNormal];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateHighlighted];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateDisabled];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel-iPad.png"] forState:UIControlStateSelected];
	}
	
	else if(xyState == accelerXYStateLandscapeLeft || xyState == accelerXYStateLandscapeRight)
	{
		backView.frame = CGRectMake(-128, 128, 1024, 768);
		albumBtn.frame = CGRectMake(-128, 128, 1024, 768);
		
		backView.image = [UIImage imageNamed:@"splash-iPad-Landscape.png"];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_Landscape-iPad.png"] forState:UIControlStateNormal];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateHighlighted];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateDisabled];
		[albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_splash_load_sel_Landscape-iPad.png"] forState:UIControlStateSelected];
	}
	
	
	[UIView beginAnimations:@"rotate" context:nil]; 
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 
	[UIView setAnimationDuration:0.3f];
	
	
	if(xyState == accelerXYStatePortrait)
	{
		transfm = CGAffineTransformIdentity;
		backView.transform = transfm;
		albumBtn.transform = transfm;
		infoBtn.transform = transfm;
		
		backView.frame = CGRectMake(0, 0, 768, 1024);
		albumBtn.frame = CGRectMake(0, 0, 768, 1024);
		infoBtn.center = CGPointMake(614, 118);
	}
	else if(xyState == accelerXYStatePortraitUpsideDown)
	{
		transfm = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
		backView.transform = transfm;
		albumBtn.transform = transfm;
		infoBtn.transform = transfm;
		
		backView.frame = CGRectMake(0, 0, 768, 1024);
		albumBtn.frame = CGRectMake(0, 0, 768, 1024);
		infoBtn.center = CGPointMake(768-614, 1024-118);
	}
	else if(xyState == accelerXYStateLandscapeLeft)
	{
		transfm = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI/2);
		backView.transform = transfm;
		albumBtn.transform = transfm;
		infoBtn.transform = transfm;
		
		infoBtn.center = CGPointMake(100, 1024-925);
	}
	else if(xyState == accelerXYStateLandscapeRight)
	{
		transfm = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
		backView.transform = transfm;
		albumBtn.transform = transfm;
		infoBtn.transform = transfm;
		
		infoBtn.center = CGPointMake(768-100, 925);
	}
	
	[UIView commitAnimations];
	
}
*/




#pragma mark -
#pragma mark delegate functions
//UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	self.albumBtn.enabled = YES;
}

//UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	
	[NSThread detachNewThreadSelector:@selector(startWait) toTarget:self withObject:nil];
	
	UIImage * selected = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	if(selected == nil) return;
	
	
	//限制一下图片的大小，如果过大，就裁剪到合适的尺寸
	float limitPixel;
	if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
	{
		if([self checkIfPureiPhone4NotIncludeIPod4])
		{
			limitPixel = photo_limit_iPhone4;
		}
		else
		{
			limitPixel = photo_limit_iPhone3_3GS;
		}
	}
	else
	{
		limitPixel = photo_limit_iPad;
	}
	selected = [self limitedSourcePhoto:selected forLimitPixel:limitPixel];
	

	//保存选中的图片
	[self saveOriginPhoto:selected];
	

	[_imagePickerPopover dismissPopoverAnimated:NO];
	self.albumBtn.enabled = YES;
	
	
	[self stopWait];
	
	//返回给appdelegate，可以进入主页面了
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(splashSelectedPhoto:)])
	{
		[self.delegate splashSelectedPhoto:selected];
	}
}





#pragma mark -
#pragma mark 为限制图片大小做的函数
-(BOOL)checkIfPureiPhone4NotIncludeIPod4
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
	char *name = (char*) malloc(size);
	sysctlbyname("hw.machine", name, &size, NULL, 0);
	NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", machine);
	free(name);
	
	NSRange range  = [machine rangeOfString:@"iPhone3"];
	if(range.length != 0)
	{
		return YES;
	}
	
	return NO;
}
-(UIImage*)limitedSourcePhoto:(UIImage*)source forLimitPixel:(float)limit
{
	CGSize sourceSize = source.size;
	if(sourceSize.width >= sourceSize.height)
	{
		if(sourceSize.width <= limit)
		{
			return source;
		}
	}
	else
	{
		if(sourceSize.height <= limit)
		{
			return source;
		}
	}
	
	//找到限制以后可以缩放到的rect
	CGRect limitedRect = [self photoRenderRectForImageSize:sourceSize withImageViewRect:CGRectMake(0.0, 0.0, limit, limit)];
	
	//把图片缩放到限制以后的大小
	UIImage *limitedImage = [self imageWithImage:source scaledToSize:limitedRect.size]; //autorelease
	
	//给缩放以后的图片增加alpha
	UIImage *alphaLimitedImage = [self imageAddAlphaForImage:limitedImage]; //autorelease
	
	return alphaLimitedImage;
}
- (CGRect)photoRenderRectForImageSize:(CGSize)imageSize withImageViewRect:(CGRect)viewRect
{
	float x = 0; //viewRect.origin.x;
	float y = 0; //viewRect.origin.y;
	float w = viewRect.size.width;
	float h = viewRect.size.height;
	
	float iw = imageSize.width;
	float ih = imageSize.height;
	
	float px;
	float py;
	float pw;
	float ph;
	
	if(iw/w >= ih/h)
	{
		pw = w;
		ph = (pw*ih)/iw;
	}
	else
	{
		ph = h;
		pw = (ph*iw)/ih;
	}
	
	px = x + (w-pw)/2;
	py = y + (h-ph)/2;
	
	
	return CGRectMake(px, py, pw, ph);
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	// Create a graphics image context
	UIGraphicsBeginImageContext(newSize);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, newSize.width, newSize.height));
	
	// Tell the old image to draw in this new context, with the desired
	// new size
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	
	// Get the new image from the context
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the context
	UIGraphicsEndImageContext();
	
	// Return the new image.
	return newImage;
}
-(UIImage*)imageAddAlphaForImage:(UIImage *)image
{
	CGImageRef CGImage = image.CGImage;
	if (!CGImage)
		return nil;
	
	// Parse CGImage info
	//	size_t bpc		= CGImageGetBitsPerComponent(CGImage);
	//	size_t bpp		= CGImageGetBitsPerPixel(CGImage);
	//  if(bpp/bpc == 4) return image;
	
	
	size_t imgWidth	= CGImageGetWidth(CGImage);
	size_t imgHeight  = CGImageGetHeight(CGImage);
	UInt8* buffer = (UInt8*)malloc(imgWidth * imgHeight * 4);
	
	
	//	CFDataRef matteData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
	//	const UInt8* pixelPtr = CFDataGetBytePtr(matteData);	
	
	//	for(int i=0; i<imgWidth*imgHeight; ++i)
	//	{
	//		buffer[i*4+0] = pixelPtr[i*bpp/bpc+0];
	//		buffer[i*4+1] = pixelPtr[i*bpp/bpc+1];
	//		buffer[i*4+2] = pixelPtr[i*bpp/bpc+2];
	//		buffer[i*4+3] = 255;
	//	}
	
	CGColorSpaceRef	desColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(buffer,
													   imgWidth,imgHeight,
													   8, 4*imgWidth,
													   desColorSpace,
													   kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(bitmapContext, CGRectMake(0.0, 0.0, (CGFloat)imgWidth, (CGFloat)imgHeight), image.CGImage);
	
	CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
	UIImage* resultImage = [UIImage imageWithCGImage:cgImage];
	
	CFRelease(desColorSpace);
	CFRelease(bitmapContext);
	CFRelease(cgImage);
	free(buffer);
	
	return resultImage;
}


@end
