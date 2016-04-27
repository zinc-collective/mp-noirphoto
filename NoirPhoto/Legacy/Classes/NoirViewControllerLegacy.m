//
//  NoirViewController.m
//  Noir
//
//  Created by jack on 6/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NoirViewControllerLegacy.h"
//#import "QuartzView.h"
#import "RConfigFile.h"
#include <sys/types.h>
#include <sys/sysctl.h>
//#import "InfoCtrlor.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DeviceDetect.h"

#define presets_plist_current @"Presets_current.pList"
#define presets_plist_default @"Presets_default.pList"

#define metadata_plist @"metadata_plist.pList"


#define ctrl_pad_head 35
#define ctrl_pad_head_ipad 125

#define IPHONE5_HEIGHT_DIFFERENCE 88 //568-480

#define photo_view_rect				CGRectMake(0.0, 0.0, 320.0, 240.0)
#define ellipse_view_rect			CGRectMake(0.0, 0.0, 320.0, 240.0)
#define ctrl_pad_view_rect			CGRectMake(0.0, 236.5, 320.0, 243.5)
#define photo_full_view_rect				CGRectMake(0.0, 0.0, 320.0, 480)
#define photo_full_view_rect2				CGRectMake(0.0, 0.0, 320.0, (480 - ctrl_pad_head))
#define ellipse_full_view_rect			CGRectMake(0.0, 0.0, 320.0, 480)

#define photo_view_rect_iphone5				CGRectMake(0.0, 0.0, 320.0, 240.0+IPHONE5_HEIGHT_DIFFERENCE)
#define ellipse_view_rect_iphone5			CGRectMake(0.0, 0.0, 320.0, 240.0+IPHONE5_HEIGHT_DIFFERENCE)
#define ctrl_pad_view_rect_iphone5			CGRectMake(0.0, 236.5+IPHONE5_HEIGHT_DIFFERENCE, 320.0, 243.5)
#define photo_full_view_rect_iphone5				CGRectMake(0.0, 0.0, 320.0, 480+IPHONE5_HEIGHT_DIFFERENCE)
#define photo_full_view_rect2_iphone5				CGRectMake(0.0, 0.0, 320.0, ((480+IPHONE5_HEIGHT_DIFFERENCE) - ctrl_pad_head))
#define ellipse_full_view_rect_iphone5			CGRectMake(0.0, 0.0, 320.0, 480+IPHONE5_HEIGHT_DIFFERENCE)

#define photo_view_rect_ipad			CGRectMake(0.0, 0.0, 768.0, 768.0)
#define ellipse_view_rect_ipad			CGRectMake(0.0, 0.0, 768.0, 768.0)
#define ctrl_pad_view_rect_ipad			CGRectMake(0.0, 768.0, 768.0, 256.0)
#define photo_full_view_rect_ipad			CGRectMake(0.0, 0.0, 768.0, 1024.0)
#define photo_full_view_rect_ipad2			CGRectMake(0.0, 0.0, 768.0, (1024.0-ctrl_pad_head_ipad))
#define ellipse_full_view_rect_ipad			CGRectMake(0.0, 0.0, 768.0, 1024.0)


#define save_origin_photo_path		@"/Documents/origin_photo.jpg"

#define photo_limit_iPhone3_3GS     2048.0
#define photo_limit_iPhone4         2592.0
#define photo_limit_iPad            2048.0


@implementation NoirViewControllerLegacy
@synthesize photoView;
@synthesize photoFullView;
@synthesize photo;
@synthesize adjustPhoto;
@synthesize renderedPhoto;
@synthesize sourcePhoto;
@synthesize preset;
@synthesize presetsItems;
@synthesize presetsChooseIndex;
@synthesize tints;
@synthesize tintsItems;
@synthesize loadBtn;
@synthesize saveBtn;
@synthesize infoBtn;
@synthesize tintMaskView;
@synthesize mCircleImageName;
@synthesize mPresetReviewImageName;
@synthesize mPresetReviewMaskImageName;
@synthesize mPresetReviewMaskSelImageName;
@synthesize savingMaskView;
@synthesize savingSpinner;

@synthesize mCirclePreset;
@synthesize mCirclePreset4;
@synthesize mCircleShow;
@synthesize mCircleShow4;
@synthesize mCircleRender;
@synthesize mCircleSave;
@synthesize imagePickerPopover;

@synthesize _vignetteView;

@synthesize _vignetteFullView;
@synthesize _sourceOrientation;


#pragma mark -
#pragma mark system functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
		
		
    }
    return self;
}

int briteLUT[256];
int darkLUT[256];
void loadGaindLUT()
{
	//load LUTs
	//
	UIImage *briteImg = [UIImage imageNamed:@"NOIR_brite_LUT.png"];
	CFDataRef briteLUTData = CGDataProviderCopyData(CGImageGetDataProvider(briteImg.CGImage));	
	int *m_briteLUTdata = (int *)CFDataGetBytePtr(briteLUTData);
	uint8_t *britePtr = (unsigned char *)&m_briteLUTdata[0];
	for (int i = 0; i < 256; i++)
	{
		briteLUT[i] = *britePtr;
		britePtr += 4;
		//NSLog(@"%d %d",i,briteLUT[i]);
	}		
	CFRelease(briteLUTData);
	
	UIImage *darkImg = [UIImage imageNamed:@"NOIR_dark_LUT.png"];
	CFDataRef darkLUTData = CGDataProviderCopyData(CGImageGetDataProvider(darkImg.CGImage));	
	int *m_darkLUTdata = (int *)CFDataGetBytePtr(darkLUTData);
	uint8_t *darkPtr = (unsigned char *)&m_darkLUTdata[0];
	for (int i = 0; i < 256; i++)
	{
		darkLUT[i] = *darkPtr;
		darkPtr += 4;
		//NSLog(@"%d %d",i,darkLUT[i]);
	}		
	CFRelease(darkLUTData);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//bret
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
}

//bret
#if 0
- (BOOL)shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	NSUInteger mask = 0;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		mask = UIInterfaceOrientationMaskPortrait;
	} else
    {
		mask = UIInterfaceOrientationMaskPortrait;
	}
	//return mask;
    return UIInterfaceOrientationMaskAll;
}
#endif

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //bret
    imagePickerOnScreen = NO;
    //init picker
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.delegate = self;
	
	_bRendering = NO;
	_bSavingOriginPhoto = NO;
	
	[self setPresetUseImageForDevice];
	
	
	//self.view.backgroundColor = [UIColor blackColor];
	
	[[RConfigFile sharedConfig] CheckAndCreateFileForName:presets_plist_current];
	[[RConfigFile sharedConfig] CheckAndCreateFileForName:presets_plist_default];
	
	
	//check the version
	[self checkTheVersionAndMoveThePresetPlist];
	
	// Load LUTs from NOIR_brite_LUT.png and NOIR_dark_LUT.png	
	//	for(int i=0; i<256; i++)
	//	{
	//		briteLUT[i] = pixel_brite;
	//		darkLUT[i] = pixel_dark;
	//	}
	
	
	loadGaindLUT();
	
	//add photo view
	CGRect photoViewRect = photo_view_rect;
    if (IS_IPHONE_5)
        photoViewRect = photo_view_rect_iphone5;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		photoViewRect = photo_view_rect_ipad;
	}
	
	UIImageView *pView = [[UIImageView alloc] initWithFrame:photoViewRect];
	self.photoView = pView;
	self.photoView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view insertSubview:self.photoView atIndex:0];
	
	
	// baiwei for full view
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		//init phont full view 
		CGRect photoFullViewRect = photo_full_view_rect_ipad;
		UIImageView *pFullView = [[UIImageView alloc] initWithFrame:photoFullViewRect];
		self.photoFullView = pFullView;
		self.photoFullView.contentMode = UIViewContentModeScaleAspectFit;
		
		
		//init full vignette view
		CGRect ellipseFullViewRect = ellipse_full_view_rect_ipad;
		_vignetteFullView = [[VignetteView alloc] initWithFrame:ellipseFullViewRect];
		_vignetteFullView.delegate = self;
		
		
		//fullBtn
        fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		fullBtn.frame = CGRectMake(725, 5-3, 40, 40);
		fullBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
		[fullBtn  setImage:[UIImage imageNamed:@"down_panel.png"] forState:UIControlStateNormal];
	} else { //iphone
		
		//fullBtn
        fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		fullBtn.frame = CGRectMake(286, -5, 40, 40);
		fullBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
		[fullBtn  setImage:[UIImage imageNamed:@"down_panel.png"] forState:UIControlStateNormal];
	}
	
	blackBackground = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 1024, 1024)];
	blackBackground.backgroundColor = [UIColor blackColor];
	
	//reload metadata
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path=[paths    objectAtIndex:0];
	NSString *filename=[path stringByAppendingPathComponent:metadata_plist];  
	BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:filename];
	if(success) {
		imageMetadata=[[NSMutableDictionary alloc] initWithContentsOfFile:filename];
		
		NSLog(@"loadImageMetadataFromDoc=%@", imageMetadata);
	}
	
	//add ellipse view
	/*
	 _ellipseView = [[QuartzView alloc] initWithFrame:ellipse_view_rect];
	 _ellipseView.backgroundColor = [UIColor clearColor];
	 //[self.view addSubview:_ellipseView];
	 [self.view insertSubview:_ellipseView atIndex:1];
	 */
	
	//add vignette view
	CGRect ellipseViewRect = ellipse_view_rect;
    if (IS_IPHONE_5)
        ellipseViewRect = ellipse_view_rect_iphone5;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		ellipseViewRect = ellipse_view_rect_ipad;
	}
	
	_vignetteView = [[VignetteView alloc] initWithFrame:ellipseViewRect];
	_vignetteView.delegate = self;
	[self.view insertSubview:_vignetteView atIndex:1];
	
	//initialize data
	self.tints = [self tintsInitialization];
	self.tintsItems = [self tintsItemsWithTints:self.tints];
	
	self.presetsItems = [self presetsItemsFromPlist:presets_plist_current];
	
	NSNumber *lastPresetIndex = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"last_preset_index"];
	if(lastPresetIndex == nil)
	{
		self.presetsChooseIndex = -1;
	}
	else
	{
		self.presetsChooseIndex = [lastPresetIndex intValue];//[self chooseIndexForPresets:self.presetsItems];
	}

	if(self.presetsChooseIndex != -1)
	{
		NSDictionary *itemDic = [self.presetsItems objectAtIndex:self.presetsChooseIndex];
		self.preset = (Preset*)[itemDic objectForKey:@"data"];
		_bPreseting = YES;
	}
	else
	{
		self.preset = [self presetFromUserDefault];
		if(self.preset == nil)
		{
			self.presetsChooseIndex = 0;
			NSDictionary *itemDic = [self.presetsItems objectAtIndex:self.presetsChooseIndex];
			self.preset = (Preset*)[itemDic objectForKey:@"data"];
			_bPreseting = YES;
		}
		else
		{
			_bPreseting = NO;
		}
	}
	
	
	//add control pad view
	CGRect ctrlPadViewRect = ctrl_pad_view_rect;
    if (IS_IPHONE_5)
        ctrlPadViewRect = ctrl_pad_view_rect_iphone5;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		ctrlPadViewRect = ctrl_pad_view_rect_ipad;
	}
	
	_ctrlPadView = [[ControlPadView alloc] initWithFrame:ctrlPadViewRect];
	[_ctrlPadView setDelegate:self];
	[self initElementsForControlPad];
	[self.view insertSubview:_ctrlPadView atIndex:2];
	
	
	//add saving mask
	UIView *smView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
	self.savingMaskView = smView;
	self.savingMaskView.backgroundColor = [UIColor blackColor];
	self.savingMaskView.alpha = 0.5;
	self.savingMaskView.hidden = YES;
	[self.view addSubview:self.savingMaskView];
	
	//add saving spinner
	UIActivityIndicatorView *smSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	smSpinner.frame = CGRectMake((self.view.frame.size.width-25.0)/2, (self.view.frame.size.height-25.0)/2, 25.0, 25.0);
	self.savingSpinner = smSpinner;
	self.savingSpinner.hidden = YES;
	[self.savingSpinner stopAnimating];
	[self.view addSubview:self.savingSpinner];
    
    
    //bret button fix-up for the 4 inch display
    if (IS_IPHONE_5)
    {
        CGRect frame = loadBtn.frame;
        frame.origin.y += IPHONE5_HEIGHT_DIFFERENCE;
        loadBtn.frame = frame;

        frame = saveBtn.frame;
        frame.origin.y += IPHONE5_HEIGHT_DIFFERENCE;
        saveBtn.frame = frame;
        
        frame = infoBtn.frame;
        frame.origin.y += IPHONE5_HEIGHT_DIFFERENCE;
        infoBtn.frame = frame;
        
        frame = tintMaskView.frame;
        frame.origin.y += IPHONE5_HEIGHT_DIFFERENCE;
        tintMaskView.frame = frame;
    }
}

-(void)loadWithSavedPhoto:(UIImage *)image {
	//set tint and adjust position
	[_ctrlPadView chooseTintsBtnForIndex:self.preset.tintIndex bNeedReturn:NO];
	[_ctrlPadView setAdjustsForExpinside:self.preset.expInside expOutside:self.preset.expOutside contrast:self.preset.contrast];
	[self changeTintMaskForIndex:self.preset.tintIndex];
	
	[self initUsedPropertiesAndUIForOriginPhoto:image];
	
}

- (void)didReceiveMemoryWarning
{
	NSLog(@"memory warnning, restore the renderedPhoto");
	
	if(self.photoView != nil && self.renderedPhoto != nil)
	{
		self.photoView.image = self.renderedPhoto;
	}
}






#pragma mark -
#pragma mark delegate functios
//ControlPadViewDelegate
-(void)presetsChooseIndex:(NSInteger)index data:(id)data
{
	self.preset = [self presetReadFromPlistByIndex:index];
	if(self.preset == nil) return;
	
	self.presetsChooseIndex = index;
	[self setPresetsItemsChooseStateForIndex:self.presetsChooseIndex];
	
	//save the presetsItems to pList
	//[self saveToPlistForPresetItems:self.presetsItems];
	
	//set vignette position
	Parameter *param = [self parameterWithPreset:self.preset];
	[_vignetteView setVignetteForParam:param photoRect:_photoRenderRect];
	
	//set tint and adjust position
	[_ctrlPadView chooseTintsBtnForIndex:self.preset.tintIndex bNeedReturn:NO];
	[_ctrlPadView setAdjustsForExpinside:self.preset.expInside expOutside:self.preset.expOutside contrast:self.preset.contrast];
	
	//change mask
	[self changeTintMaskForIndex:self.preset.tintIndex];
	
	//render
	[self renderPhotoViewForPreset:self.preset useImage:self.photo changeType:typePreset actioning:NO];
	
	
	_bPreseting = YES;
	
	//save preset choose index to user default
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:index] forKey:@"last_preset_index"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}
-(void)tintsChooseIndex:(NSInteger)index data:(id)data
{
	self.preset.tintIndex = index;
	
	//change mask
	[self changeTintMaskForIndex:index];
	
	//remove select state of presets buttons
	[_ctrlPadView choosePresetsBtnForIndex:-1 bNeedReturn:NO];
	_bPreseting = NO;
	
	//save preset choose index to user default
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:-1] forKey:@"last_preset_index"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	
	//render
	[self renderPhotoViewForPreset:self.preset useImage:self.photo changeType:typeTint actioning:NO];
}
-(void)adjustExpinside:(float)expInside expOutside:(float)expOutside contrast:(float)contrast isFinal:(BOOL)isFinal
{
	if(_bPreseting)
	{
		//remove select state of presets buttons
		[_ctrlPadView choosePresetsBtnForIndex:-1 bNeedReturn:NO];
		_bPreseting = NO;
		
		//save preset choose index to user default
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:-1] forKey:@"last_preset_index"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	
	self.preset.expInside = expInside;
	self.preset.expOutside = expOutside;
	self.preset.contrast = contrast;
	
	//render
	if(isFinal)
	{
		//use self.photo
		_bRendering = NO;
		[self renderPhotoViewForPreset:self.preset useImage:self.photo changeType:typeAdjust actioning:NO];
	}
	else
	{
		//use self.adjustPhoto
		[self renderPhotoViewForPreset:self.preset useImage:self.adjustPhoto changeType:typeAdjust actioning:YES];
	}
	
}
-(void)presetsResetToDefault
{
	self.presetsItems = [self presetsItemsFromPlist:presets_plist_default];
	self.presetsChooseIndex = [self chooseIndexForPresets:self.presetsItems];
	
	[_ctrlPadView setPresetsForItems:self.presetsItems];
	[_ctrlPadView choosePresetsBtnForIndex:self.presetsChooseIndex bNeedReturn:YES];
	
	if(self.presetsChooseIndex == -1)
	{	
		[_ctrlPadView chooseTintsBtnForIndex:-1 bNeedReturn:NO];
		[_ctrlPadView setAdjustsForExpinside:inside_slider_default_value expOutside:outside_slider_default_value contrast:contrast_slider_default_valut];
		
		self.preset = nil;
		[self renderPhotoViewForPreset:self.preset useImage:self.photo changeType:typeNone actioning:NO];
	}
	
	
	//save the presetsItems to pList
	[self saveToPlistForPresetItems:self.presetsItems];
	
}
-(void)overWritePresetToIndex:(NSInteger)index
{
	//got the self.preset and save it to presetsItems array
    Preset *ovPreset = [[Preset alloc] init];
	ovPreset.index = index;
	ovPreset.expInside = self.preset.expInside;
	ovPreset.expOutside = self.preset.expOutside;
	ovPreset.contrast = self.preset.contrast;
	ovPreset.tintIndex = self.preset.tintIndex;
	ovPreset.ellipseCenterX = self.preset.ellipseCenterX;
	ovPreset.ellipseCenterY = self.preset.ellipseCenterY;
	ovPreset.ellipseA = self.preset.ellipseA;
	ovPreset.ellipseB = self.preset.ellipseB;
	ovPreset.ellipseAngle = self.preset.ellipseAngle;
	ovPreset.selected = YES;
	
	
	//replace the data for current preset
	NSMutableDictionary *item = [self.presetsItems objectAtIndex:index];
	[item setObject:ovPreset forKey:@"data"];
	
	//根据preset获取相应的review图片，并设定到items里面
    // "Obtain the appropriate review under preset picture and set it to items inside" (via Google Translate)
	self.mCircleImageName = [self circleImageNameForState:1];//@"circle_preset.png";
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		UIImage *renImage = [self imageForPreset:self.preset useImage:[UIImage imageNamed:self.mPresetReviewImageName]];//@"preset_review.png"
		UIImage *image    = [UIImage imageNamed:self.mPresetReviewMaskImageName];//[self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskImageName]];//@"preset_review_mask.png"
		UIImage *imageSel = [UIImage imageNamed:self.mPresetReviewMaskSelImageName];//[self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskSelImageName]];//@"preset_review_mask_sel.png
		[item setObject:renImage forKey:@"image_show"];
		[item setObject:image forKey:@"image"];
		[item setObject:imageSel forKey:@"image_sel"];
	}
	else
	{
		UIImage *renImage = [self imageForPreset:self.preset useImage:[UIImage imageNamed:self.mPresetReviewImageName]];//@"preset_review.png"
		UIImage *image    = [self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskImageName]];//@"preset_review_mask.png"
		UIImage *imageSel = [self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskSelImageName]];//@"preset_review_mask_sel.png
		[item setObject:image forKey:@"image"];
		[item setObject:imageSel forKey:@"image_sel"];
	}

	
	//select the overwrite presets buttons
	self.presetsChooseIndex = index;
	[_ctrlPadView setPresetsForItems:self.presetsItems];
	[_ctrlPadView choosePresetsBtnForIndex:self.presetsChooseIndex bNeedReturn:NO];
	
	//set the choose state for all presets
	[self setPresetsItemsChooseStateForIndex:self.presetsChooseIndex];
	
	//save the presetsItems to pList
	[self saveToPlistForPresetItems:self.presetsItems];
	
	//reload the presetsItems
	self.presetsItems = [self presetsItemsFromPlist:presets_plist_current];
	self.preset = [self presetReadFromPlistByIndex:self.presetsChooseIndex];
}

//UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	
	//if(_bSavingOriginPhoto) return;
    //bret
    imagePickerOnScreen = NO;
	NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    UIImage * selected = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self pickPhoto:assetURL image:selected];
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[self.imagePickerPopover dismissPopoverAnimated:YES];
		self.loadBtn.enabled = YES;
	}
	else
	{
        [picker dismissViewControllerAnimated:YES completion:^{}];
	}

}

-(void)pickPhoto:(NSURL*)assetURL image:(UIImage*)selected {
	
	if(selected == nil) return;
    
//	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//	
//	if (version > 4.1) {
		
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library assetForURL:assetURL
				 resultBlock:^(ALAsset *asset)  {
					 NSDictionary *metadata = asset.defaultRepresentation.metadata;
					 
					 //NSLog(@"metadata=, %@", metadata);
					 
					 //imageMetadata = nil;
					 imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:metadata];
					 //[self addEntriesFromDictionary:metadata];
					 
					 NSLog(@"loadImageMetadataFromPic=%@", imageMetadata);
					 
					 NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
					 NSString *path=[paths    objectAtIndex:0];
					 NSString *filename=[path stringByAppendingPathComponent:metadata_plist];    
					 
					 [imageMetadata writeToFile:filename  atomically:YES];
				 }
				failureBlock:^(NSError *error) {
				}];
//	} else {
//		imageMetadata = nil;
//		
//		NSFileManager *fileManage = [NSFileManager defaultManager];
//		NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//		NSString *path=[paths    objectAtIndex:0];
//		[fileManage removeItemAtPath:[path stringByAppendingPathComponent: metadata_plist] error:nil];
//		
//		
//	}
	
	//NSLog(@"selected origation: %d", selected.imageOrientation);
	
	/*	
	 
	 //save the source photo
	 self.sourcePhoto = selected;
	 
	 //save the orientation
	 _sourceOrientation = selected.imageOrientation;
	 
	 //calculate the render Rect
	 CGRect photoPlaceRect = [self photoRenderRectForImageSize:selected.size withImageViewRect:photo_view_rect];
	 
	 //got self.photo
	 self.photo = [self imageWithImage:selected scaledToSize:CGSizeMake(photoPlaceRect.size.width, photoPlaceRect.size.height)];
	 
	 //add alpha
	 self.photo = [self imageAddAlphaForImage:self.photo];
	 
	 
	 //got photo renderRect
	 _photoRenderRect = [self photoRenderRectForImageSize:self.photo.size withImageViewRect:photo_view_rect];
	 
	 
	 //render the photo
	 [self renderPhotoViewForPreset:self.preset useImage:self.photo changeType:typeNone actioning:NO];
	 
	 
	 //set vignette position
	 Parameter *param = [self parameterWithPreset:self.preset];
	 [_vignetteView setVignetteForParam:param photoRect:_photoRenderRect];
	 
	 
	 //make out the adjustPhoto
	 self.adjustPhoto = [self imageWithImage:self.photo scaledToSize:CGSizeMake(self.photo.size.width/2,self.photo.size.height/2)];
	 self.adjustPhoto = [self imageAddAlphaForImage:self.adjustPhoto];
	 */
	
	
	//初始化使用限制过的的图片
	[self initUsedPropertiesAndUIForOriginPhoto:selected];
	
	//save origin photo
	_bSavingOriginPhoto = YES;
	[NSThread detachNewThreadSelector:@selector(saveOriginPhoto:) toTarget:self withObject:self.sourcePhoto];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //bret
    imagePickerOnScreen = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//bret
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}




//VignetteDelegate
-(void)vignetteViewDidChange:(Parameter*)parameter isFinal:(BOOL)isFinal bChangePresetState:(BOOL)bChange
{
	if(bChange)
	{
		if(_bPreseting)
		{
			//remove select state of presets buttons
			[_ctrlPadView choosePresetsBtnForIndex:-1 bNeedReturn:NO];
			_bPreseting = NO;
			
			//save preset choose index to user default
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:-1] forKey:@"last_preset_index"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	
	self.preset.ellipseCenterX	= parameter.ellipseCenterX;
	self.preset.ellipseCenterY	= parameter.ellipseCenterY;
	self.preset.ellipseA		= parameter.ellipseA;
	self.preset.ellipseB		= parameter.ellipseB;
	self.preset.ellipseAngle	= parameter.ellipseAngle;
	
	//render
	if(isFinal)
	{
		//use self.photo
		_bRendering = NO;
		[self renderPhotoViewForPreset:self.preset useImage:self.photo changeType:typeVignette actioning:NO];
	}
	else
	{
		//use self.adjustPhoto
		[self renderPhotoViewForPreset:self.preset useImage:self.adjustPhoto changeType:typeVignette actioning:YES];
	}
}

//UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	//[popoverController release];
	self.loadBtn.enabled = YES;
}




//#pragma mark -
//#pragma mark in use functios @for UI
//-(void)fullBtn:(id)sender
//{
//	
//	[UIView beginAnimations:@"rotate" context:nil]; 
//	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 
//	[UIView setAnimationDuration:0.3];
//	[UIView setAnimationDelegate:self];
//	//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:photoFullView cache:YES];
//	
//	if (isFull == 0) {
//		
//		//[self.view addSubview:blackBackground];
//		
//		//photoFullView.backgroundColor = [UIColor blackColor];
//		//		photoFullView.image = renderedPhoto;
//		//[self.view addSubview:photoFullView];
//		
//		Parameter *param = [self parameterWithPreset:self.preset];
//		
//		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//			ctrl_pad_offset = 256 - ctrl_pad_head_ipad;
//			float photoImageViewH = 1024-ctrl_pad_head_ipad;
//			
//			//full photo view
//			//photoView.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
//			photoView.frame = photo_full_view_rect_ipad2;
//			photoView.image = renderedPhoto;
//			
//			//full vignette view
//			//_vignetteView.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
//			_vignetteView.frame = photo_full_view_rect_ipad2;
//			
//			if (renderedPhoto.size.width/renderedPhoto.size.height < 768/photoImageViewH) {
//				CGFloat w = photoImageViewH*renderedPhoto.size.width/renderedPhoto.size.height;
//				CGFloat h = photoImageViewH;
//				
//				_photoRenderRect2 = _photoRenderRect;
//				_photoRenderRect = CGRectMake((768-w)/2, 0, w, h);
//				
//				//[_vignetteFullView setVignetteForParam:param photoRect:CGRectMake((768-w)/2, 0, w, h)];
//			}
//				
//			[_vignetteView setVignetteForParam:param photoRect:_photoRenderRect];
//			
//			//[_vignetteFullView setVignetteForParam:param photoRect:photoFullView.frame];
//		} else { //iphone
//			ctrl_pad_offset = 240 - ctrl_pad_head;
//			//bret
//            //if (IS_IPHONE_5)
//            //    ctrl_pad_offset = (568/2) - ctrl_pad_head;
//
//			//full photo view
//			photoView.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
//			photoView.frame = photo_full_view_rect2;
//            if (IS_IPHONE_5)
//                photoView.frame = photo_full_view_rect2_iphone5;
//			photoView.image = renderedPhoto;
//			
//			//full vignette view
//			_vignetteView.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
//			_vignetteView.frame = photo_full_view_rect2;
//            if (IS_IPHONE_5)
//                _vignetteView.frame = photo_full_view_rect2_iphone5;
//			
//			//NSLog(@"w=%f, h = %f",renderedPhoto.size.width, renderedPhoto.size.height);
//			//			NSLog(@"bili=%f",renderedPhoto.size.width/renderedPhoto.size.height);
//			//			NSLog(@"bili2=%f",(480-ctrl_pad_head)/320);
//			
//			float photoImageViewH = 480-ctrl_pad_head;
//			//bret
//            if (IS_IPHONE_5)
//                photoImageViewH = 568-ctrl_pad_head;
//            
//			if ((renderedPhoto.size.width/renderedPhoto.size.height) > photoImageViewH/320) {
//				CGFloat w = photoImageViewH;
//				CGFloat h = photoImageViewH*renderedPhoto.size.height/renderedPhoto.size.width;
//				
//				_photoRenderRect2 = _photoRenderRect;
//				_photoRenderRect = CGRectMake(0, (320-h)/2, w, h);
//				
//				
//			} else {
//				CGFloat w = 320*renderedPhoto.size.width/renderedPhoto.size.height;
//				CGFloat h = 320;
//				
//				_photoRenderRect2 = _photoRenderRect;
//				_photoRenderRect = CGRectMake((photoImageViewH-w)/2, 0, w, h);
//				
//			}
//			
//			[_vignetteView setVignetteForParam:param photoRect:_photoRenderRect];
//			
//			
//		}
//		
//		[fullBtn  setImage:[UIImage imageNamed:@"up_panel.png"] forState:UIControlStateNormal];
//		
//		_ctrlPadView.center = CGPointMake(_ctrlPadView.center.x, _ctrlPadView.center.y+ctrl_pad_offset);
//		tintMaskView.center = CGPointMake(tintMaskView.center.x, tintMaskView.center.y+ctrl_pad_offset);
//		loadBtn.center = CGPointMake(loadBtn.center.x, loadBtn.center.y+ctrl_pad_offset);
//		saveBtn.center = CGPointMake(saveBtn.center.x, saveBtn.center.y+ctrl_pad_offset);
//		infoBtn.center = CGPointMake(infoBtn.center.x, infoBtn.center.y+ctrl_pad_offset);
//		
//		//[self.view addSubview:_vignetteFullView];
//		//[self.view addSubview:fullBtn];
//		
//		[_ctrlPadView addSubview:fullBtn];
//		
//		isFull = 1;
//	} else { //full
//		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//			photoView.frame = photo_view_rect_ipad;
//			photoView.image = renderedPhoto;
//			
//			_vignetteView.frame = photo_view_rect_ipad;
//		} else { //iphone
//			photoView.transform = CGAffineTransformMakeRotation(0);
//			photoView.frame = photo_view_rect;
//            if (IS_IPHONE_5)
//                photoView.frame = photo_view_rect_iphone5;
//            
//			photoView.image = renderedPhoto;
//			
//			_vignetteView.transform = CGAffineTransformMakeRotation(0);
//			_vignetteView.frame = photo_view_rect;
//            if (IS_IPHONE_5)
//                _vignetteView.frame = photo_view_rect_iphone5;
//		}
//		
//		[fullBtn  setImage:[UIImage imageNamed:@"down_panel.png"] forState:UIControlStateNormal];
//		
//		_ctrlPadView.center = CGPointMake(_ctrlPadView.center.x, _ctrlPadView.center.y-ctrl_pad_offset);
//		tintMaskView.center = CGPointMake(tintMaskView.center.x, tintMaskView.center.y-ctrl_pad_offset);
//		loadBtn.center = CGPointMake(loadBtn.center.x, loadBtn.center.y-ctrl_pad_offset);
//		saveBtn.center = CGPointMake(saveBtn.center.x, saveBtn.center.y-ctrl_pad_offset);
//		infoBtn.center = CGPointMake(infoBtn.center.x, infoBtn.center.y-ctrl_pad_offset);
//		
//		Parameter *param = [self parameterWithPreset:self.preset];
//		
//		_photoRenderRect = _photoRenderRect2;
//		[_vignetteView setVignetteForParam:param photoRect:_photoRenderRect];
//		
//		isFull = 0;
//		
//		//[blackBackground removeFromSuperview];
//		//		[photoFullView removeFromSuperview];
//		//		[_vignetteFullView removeFromSuperview];
//	}
//	
//	
//	[UIView commitAnimations];
//	
//	
//}

-(IBAction)loadAction:(id)sender
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		if(imagePickerPopover==nil){
			
			UIPopoverController *ipPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
			self.imagePickerPopover = ipPopover;
			
			self.imagePickerPopover.delegate = self;
			self.imagePickerPopover.popoverContentSize = CGSizeMake(320, 480);
            
            //self.imagePickerPopover.popoverArrowDirection = UIPopoverArrowDirectionAny;

		}
		
		UIButton *btn = (UIButton*)sender;
		CGRect popFrom;
		if(btn == self.loadBtn)
		{
			popFrom = btn.bounds;
		}
		else
		{
			popFrom = CGRectMake(585, 795, 50, 50);
		}
        
//        CGAffineTransform m = CGAffineTransformMakeRotation(M_PI/2.0);
//        imagePickerPopover.transform = m;
        
		[self.imagePickerPopover presentPopoverFromRect:popFrom
												 inView:btn
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
		
		self.loadBtn.enabled = NO;
	}
	else
	{
        imagePickerOnScreen = YES;
        [self presentViewController:imagePicker animated:TRUE completion:nil];
        //[self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
//		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//		picker.delegate = self;
//		[self presentModalViewController:picker animated:YES];
//		[picker release];
		
	}
}
-(IBAction)infoAction:(id)sender
{
	NSString *infoNibName = @"Info";
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		infoNibName = @"Info-iPad";
	}
	
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Info" bundle:NULL];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"InfoViewController"];
    [self.navigationController pushViewController:vc animated:true];
}

-(void)initElementsForControlPad
{
	//add presets
	[_ctrlPadView setPresetsForItems:self.presetsItems];
	[_ctrlPadView choosePresetsBtnForIndex:self.presetsChooseIndex bNeedReturn:NO];
	
	[_ctrlPadView addSubview:fullBtn];
	
	//add reset Reset button
	//[_ctrlPadView setResetBtnForPresets];
	
	
	//add tints
	[_ctrlPadView setTintsForItems:self.tintsItems];
	if(self.presetsChooseIndex != -1)
	{
		[_ctrlPadView chooseTintsBtnForIndex:self.preset.tintIndex bNeedReturn:NO];
		[self changeTintMaskForIndex:self.preset.tintIndex];
	}
	
	//add Adjusts
	if(self.presetsChooseIndex != -1)
	{
		[_ctrlPadView setAdjustsForExpinside:self.preset.expInside expOutside:self.preset.expOutside contrast:self.preset.contrast];
	}
	else
	{
		[_ctrlPadView setAdjustsForExpinside:inside_slider_default_value expOutside:outside_slider_default_value contrast:contrast_slider_default_valut];
	}
	
}
-(NSArray*)presetsItemsFromPlist:(NSString*)fileName
{
	//未完成 @图片没换
	//read out all presets from plist
	NSArray *allPresets = [self allPresetsReadFromPlist:fileName];
	if(allPresets == nil || [allPresets count] == 0) return nil;
	
	//make up all presets items form all presets
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:6];
	for(Preset *apreset in allPresets)
	{
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
		[item setObject:apreset forKey:@"data"];
		
		//根据preset获取相应的review图片，并设定到items里面
		self.mCircleImageName = [self circleImageNameForState:1];//@"circle_preset.png";
		
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			UIImage *renImage = [self imageForPreset:apreset useImage:[UIImage imageNamed:self.mPresetReviewImageName]];//@"preset_review.png"
			UIImage *image    = [UIImage imageNamed:self.mPresetReviewMaskImageName];//[self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskImageName]];//@"preset_review_mask.png"
			UIImage *imageSel = [UIImage imageNamed:self.mPresetReviewMaskSelImageName];//[self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskSelImageName]];//@"preset_review_mask_sel.png"
			[item setObject:renImage forKey:@"image_show"];
			[item setObject:image forKey:@"image"];
			[item setObject:imageSel forKey:@"image_sel"];
		}
		else
		{
			UIImage *renImage = [self imageForPreset:apreset useImage:[UIImage imageNamed:self.mPresetReviewImageName]];//@"preset_review.png"
			UIImage *image    = [self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskImageName]];//@"preset_review_mask.png"
			UIImage *imageSel = [self imageCompiledForOriginImage:renImage maskImage:[UIImage imageNamed:self.mPresetReviewMaskSelImageName]];//@"preset_review_mask_sel.png"
			[item setObject:image forKey:@"image"];
			[item setObject:imageSel forKey:@"image_sel"];
		}

		
		[items addObject:item];
	}
	
	return items;
}
-(void)saveToPlistForPresetItems:(NSArray*)presetItems
{
	if(presetItems == nil || [presetItems count] == 0) return;
	
    NSMutableArray *allPresetDics = [[NSMutableArray alloc] initWithCapacity:6];
	
	//for(NSDictionary *itemDic in presetItems)
	for(int i=0; i<[presetItems count]; i++)
	{
		NSDictionary *itemDic = [presetItems objectAtIndex:i];
		Preset *apreset = (Preset*)[itemDic objectForKey:@"data"];
		
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:11];
		[dic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
		[dic setObject:[NSNumber numberWithFloat:apreset.expInside] forKey:@"expInside"];
		[dic setObject:[NSNumber numberWithFloat:apreset.expOutside] forKey:@"expOutside"];
		[dic setObject:[NSNumber numberWithFloat:apreset.contrast] forKey:@"contrast"];
		[dic setObject:[NSNumber numberWithInteger:apreset.tintIndex] forKey:@"tintIndex"];
		[dic setObject:[NSNumber numberWithFloat:apreset.ellipseCenterX] forKey:@"ellipseCenterX"];
		[dic setObject:[NSNumber numberWithFloat:apreset.ellipseCenterY] forKey:@"ellipseCenterY"];
		[dic setObject:[NSNumber numberWithFloat:apreset.ellipseA] forKey:@"ellipseA"];
		[dic setObject:[NSNumber numberWithFloat:apreset.ellipseB] forKey:@"ellipseB"];
		[dic setObject:[NSNumber numberWithFloat:apreset.ellipseAngle] forKey:@"ellipseAngle"];
		[dic setObject:[NSNumber numberWithBool:apreset.selected] forKey:@"selected"];
		
		[allPresetDics addObject:dic];
	}
	
	[[RConfigFile sharedConfig] DeleteConfigFileForName:presets_plist_current];
	[[RConfigFile sharedConfig] WriteConfigArrayToFile:presets_plist_current withData:allPresetDics];
	
}
-(Preset*)presetReadFromPlistByIndex:(NSInteger)index
{
	NSArray *allPresets = [self allPresetsReadFromPlist:presets_plist_current];
	if(allPresets == nil || [allPresets count] == 0) return nil;
	
	return [allPresets objectAtIndex:index];
}
-(NSArray*)allPresetsReadFromPlist:(NSString*)fileName
{
	NSArray *allPresetDics = [[RConfigFile sharedConfig] ReadConfigArrayFromFile:fileName];
	if(allPresetDics == nil || [allPresetDics count] == 0) return nil;
	
    NSMutableArray *allPresets = [[NSMutableArray alloc] initWithCapacity:6];
	
	for(NSDictionary *dic in allPresetDics)
	{
        Preset *apreset = [[Preset alloc] init];
		apreset.index = [(NSNumber*)[dic objectForKey:@"index"] intValue];
		apreset.expInside = [(NSNumber*)[dic objectForKey:@"expInside"] floatValue];
		apreset.expOutside = [(NSNumber*)[dic objectForKey:@"expOutside"] floatValue];
		apreset.contrast = [(NSNumber*)[dic objectForKey:@"contrast"] floatValue];
		apreset.tintIndex = [(NSNumber*)[dic objectForKey:@"tintIndex"] intValue];
		apreset.ellipseCenterX = [(NSNumber*)[dic objectForKey:@"ellipseCenterX"] floatValue];
		apreset.ellipseCenterY = [(NSNumber*)[dic objectForKey:@"ellipseCenterY"] floatValue];
		apreset.ellipseA = [(NSNumber*)[dic objectForKey:@"ellipseA"] floatValue];
		apreset.ellipseB = [(NSNumber*)[dic objectForKey:@"ellipseB"] floatValue];
		apreset.ellipseAngle = [(NSNumber*)[dic objectForKey:@"ellipseAngle"] floatValue];
		apreset.selected = [(NSNumber*)[dic objectForKey:@"selected"] boolValue];
		
		[allPresets addObject:apreset];
	}
	
	return allPresets;
}
-(NSArray*)tintsItemsWithTints:(NSArray*)theTints
{
	if(theTints == nil || [theTints count] == 0) return nil;
	
	
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:4];
	
	for(int i=0; i<4; i++)
	{
		Tint *tint = (Tint*)[theTints objectAtIndex:i];
		NSString *imageName    = [NSString stringWithFormat:@"tint_btn_%d.png", i];
		NSString *imageNameSel = [NSString stringWithFormat:@"tint_btn_sel_%d.png", i];
		
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			imageName    = [NSString stringWithFormat:@"tint_btn_iPad_%d.png", i];
			imageNameSel = [NSString stringWithFormat:@"tint_btn_sel_iPad_%d.png", i];
		}
		
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
		[item setObject:[UIImage imageNamed:imageName] forKey:@"image"];
		[item setObject:[UIImage imageNamed:imageNameSel] forKey:@"image_sel"];
		[item setObject:tint forKey:@"data"];
		
		[items addObject:item];
	}
	
	return items;
}
-(NSInteger)chooseIndexForPresets:(NSArray*)presets
{
	NSInteger index = 0; //-1
	if(self.presetsItems == nil || [self.presetsItems count] == 0) return index;
	
	for(NSDictionary *itemDic in self.presetsItems)
	{
		Preset *apre = (Preset*)[itemDic objectForKey:@"data"];
		if(apre.selected)
		{
			index = apre.index;
			break;
		}
	}
	
	return index;
}
-(void)setPresetsItemsChooseStateForIndex:(NSInteger)chooseIndex
{
	if(self.presetsItems == nil || [self.presetsItems count] == 0) return;
	
	for(NSDictionary *itemDic in self.presetsItems)
	{
		Preset *apre = (Preset*)[itemDic objectForKey:@"data"];
		if(apre.index == chooseIndex)
		{
			apre.selected = YES;
		}
		else
		{
			apre.selected = NO;
		}
	}
	
}



-(ffRenderArguments)argumentsWithPreset:(Preset*)apreset
{
	ffRenderArguments renderArgs;
	renderArgs.inExp			= apreset.expInside;
	renderArgs.outExp			= apreset.expOutside;
	renderArgs.noir_contrast	= apreset.contrast;
	renderArgs.ellipse_center   = CGPointMake(apreset.ellipseCenterX, apreset.ellipseCenterY);
	renderArgs.ellipse_a		= apreset.ellipseA;
	renderArgs.ellipse_b		= apreset.ellipseB;
	renderArgs.ellipse_angle	= apreset.ellipseAngle;
	renderArgs.tint				= (int) apreset.tintIndex;
	
	
	//-----for test
	//	renderArgs.inExp			= 4.0;
	//	renderArgs.outExp			= -3.0;
	//	renderArgs.noir_contrast	= 2.0;
	//	renderArgs.ellipse_center   = CGPointMake(0, 0);
	//	renderArgs.ellipse_a		= 1.0;
	//	renderArgs.ellipse_b		= 1.0;
	//	renderArgs.ellipse_angle	= 0.0;
	//	renderArgs.tint				= 3;
	//-----
	
	
	return renderArgs;
}
-(Parameter*)parameterWithPreset:(Preset*)aPreset
{
    Parameter *param = [[Parameter alloc] init];
	param.ellipseCenterX = aPreset.ellipseCenterX;
	param.ellipseCenterY = aPreset.ellipseCenterY;
	param.ellipseA       = aPreset.ellipseA;
	param.ellipseB		 = aPreset.ellipseB;
	param.ellipseAngle   = aPreset.ellipseAngle;
	
	
	return param;
}
-(void)renderPhotoViewForPreset:(Preset*)apreset useImage:(UIImage*)image changeType:(ChangeType)changeType actioning:(BOOL)bActioning
{
	if(apreset == nil) return;
	if(image == nil) return;
	
	@synchronized(self)
	{
		if(bActioning)
		{
			self.mCircleImageName = [self circleImageNameForState:3];//@"circle_render.png";
		}
		else
		{
			self.mCircleImageName = [self circleImageNameForState:2];//@"circle_show.png";
		}
		
		
		/*
		 ffRenderArguments renderArgs = [self argumentsWithPreset:apreset];
		 //self.photoView.image = [self renderForArguments:renderArgs useImage:image changeType:changeType];
		 self.renderedPhoto = [self renderForArguments:renderArgs useImage:image changeType:changeType];
		 self.photoView.image = self.renderedPhoto;
		 */
		
		//use thread to render
		if(_bRendering) return;
		_bRendering = YES;
		
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
		[params setObject:apreset forKey:@"render_preset"];
		[params setObject:image forKey:@"render_image"];
		[params setObject:[NSNumber numberWithInt:changeType] forKey:@"render_changeType"];
		
		[NSThread detachNewThreadSelector:@selector(threadRenderForArguments:) toTarget:self withObject:params];
	}
}
-(void)threadRenderForArguments:(NSDictionary*)params
{
	if(params == nil) return;
	
	Preset *apreset = (Preset*)[params objectForKey:@"render_preset"];
	UIImage *image = (UIImage*)[params objectForKey:@"render_image"];
	ChangeType changeType = [(NSNumber*)[params objectForKey:@"render_changeType"] intValue];
	
	ffRenderArguments renderArgs = [self argumentsWithPreset:apreset];
	self.renderedPhoto = [self renderForArguments:renderArgs useImage:image changeType:changeType];
	self.photoView.image = self.renderedPhoto;
	
	self.photoFullView.image = self.renderedPhoto;
	
	_bRendering = NO;
}

-(UIImage*)imageForPreset:(Preset*)apreset useImage:(UIImage*)image
{
	if(image == nil) return nil;
	
	//add alpha
	UIImage *alphaPhoto = [self imageAddAlphaForImage:image];
	
	ffRenderArguments renderArgs = [self argumentsWithPreset:apreset];
	UIImage *newImage = [self renderForArguments:renderArgs useImage:alphaPhoto changeType:typeNone];
	return newImage;
}
-(UIImage*)imageCompiledForOriginImage:(UIImage*)originImage maskImage:(UIImage*)maskImage
{
	if(originImage == nil) return nil;
	if(maskImage == nil) return nil;
	
	float oriX = (maskImage.size.width-originImage.size.width)/2;
	float oriY = (maskImage.size.height-originImage.size.height)/2;
	
	CGSize coverSize = maskImage.size;
	
	UIGraphicsBeginImageContext(coverSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	
    // full the color in the context
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, coverSize.width, coverSize.height));
    
    // draw source image on the context
	[maskImage drawInRect:CGRectMake(0.0, 0.0, maskImage.size.width, maskImage.size.height)];
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[originImage drawInRect:CGRectMake(oriX+2, oriY-2, originImage.size.width, originImage.size.height)];
	}
	else
	{
		[originImage drawInRect:CGRectMake(oriX+3, oriY-3, originImage.size.width, originImage.size.height)];
	}
	
	
    UIImage* compiledPhoto = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
	
	//这个地方是把preset的图片缩小一半，用在本来都用大图的时候，暂时可以注释掉
    // "This place is reduced to half of the preset picture, could have been used in a large image, it can temporarily comment" (via Google Translate)
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		BOOL bIphone4 = [self checkIfiPhone4];
		if(!bIphone4)
		{
			compiledPhoto = [self imageWithImage:compiledPhoto scaledToSize:CGSizeMake(46.0, 40.0) renderedForUI:YES];
		}
	}
	
    return compiledPhoto;
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

	if( image.imageOrientation == UIImageOrientationDown )
    {
        // flip it- the image is upside down and all matte generation is right side up
        // we'll just work with it upright and not do the final flip at the end
        // This is mainly because UIImage's orientation property is read only
        
        CGContextTranslateCTM(bitmapContext, 0, image.size.height);
        CGContextScaleCTM(bitmapContext, 1.0, -1.0);
    }
    
    CGContextDrawImage(bitmapContext, CGRectMake(0.0, 0.0, (CGFloat)imgWidth, (CGFloat)imgHeight), image.CGImage);
	
	CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
	UIImage* resultImage = [UIImage imageWithCGImage:cgImage];
	
	CFRelease(desColorSpace);
	CFRelease(bitmapContext);
	CFRelease(cgImage);
	free(buffer);
	
	return resultImage;
}


// Images that are elements of the user interface should be rendered at the device's
// native pixel density (non-retina vs retina). However, images selected by the user to be
// manipulated as part of the function of the application should be rendered at normal
// pixel density (that is, in CoreGraphics at a scale of 1.0).
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize renderedForUI:(BOOL)usesDevicePixelDensity
{
	// Create a graphics image context
    BOOL isOpaque = YES;
    double coregraphics_scaling = 1.0;
    if (usesDevicePixelDensity) {
        // Setting scale option to 0.0 means use the host device's resolution is
        // automatically determined at runtime by the underlying CoreGraphics library
        // (aka 2.0 on retina displays, 1.0 on non-retina displays)
        coregraphics_scaling = 0.0;
        isOpaque = NO;
    }
    UIGraphicsBeginImageContextWithOptions(newSize, isOpaque, coregraphics_scaling);  
	//UIGraphicsBeginImageContext(newSize); // IMPORTANT Prior to iOS 4, this method was the only option available in the SDK.  It would always uses opaque = NO,  CoreGraphics pixel density scale = 1.0
	
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
-(NSString*)circleImageNameForState:(NSInteger)state
{
	NSString *imageName;
	
	BOOL isIphone4 = [self checkIfiPhone4];
	
	if(state == 1)        //circle for preset
	{
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			imageName = @"circle_preset_4.png";
		}
		else
		{
			if(isIphone4)
			{
				imageName = @"circle_preset_4.png";
			}
			else
			{
				imageName = @"circle_preset.png";
			}
		}
	}
	else if(state == 2)   //circle for show
	{
		//		if(isIphone4)
		//		{
		//			imageName = @"circle_show_4.png";
		//		}
		//		else
		//		{
		//			imageName = @"circle_show.png";
		//		}
		
		//不管是不是iphone4都使用241x241的circle进行渲染
		imageName = @"circle_show.png";
	}
	else if(state == 3)	  //circle for render
	{
		imageName = @"circle_render.png";
	}
	else                  //circle for save rendering
	{
		imageName = @"circle.png";
	}
	
	return imageName;
	
}
-(UIImage*)circleImageForName:(NSString*)imageName
{
	if(imageName == nil || [imageName compare:@""] == NSOrderedSame) return nil;
	
	UIImage *circleImage = nil;
	if([imageName compare:@"circle_preset_4.png"] == NSOrderedSame)
	{
		if(self.mCirclePreset4 == nil)
		{
			self.mCirclePreset4 = [UIImage imageNamed:imageName];
		}
		circleImage = self.mCirclePreset4;
	}
	else if([imageName compare:@"circle_preset.png"] == NSOrderedSame)
	{
		if(self.mCirclePreset == nil)
		{
			self.mCirclePreset = [UIImage imageNamed:imageName];
		}
		circleImage = self.mCirclePreset;
	}
	else if([imageName compare:@"circle_show_4.png"] == NSOrderedSame)
	{
		if(self.mCircleShow4 == nil)
		{
			self.mCircleShow4 = [UIImage imageNamed:imageName];
		}
		circleImage = self.mCircleShow4;
	}
	else if([imageName compare:@"circle_show.png"] == NSOrderedSame)
	{
		if(self.mCircleShow == nil)
		{
			self.mCircleShow = [UIImage imageNamed:imageName];
		}
		circleImage = self.mCircleShow;
	}
	else if([imageName compare:@"circle_render.png"] == NSOrderedSame)
	{
		if(self.mCircleRender == nil)
		{
			self.mCircleRender = [UIImage imageNamed:imageName];
		}
		circleImage = self.mCircleRender;
	}
	else if([imageName compare:@"circle.png"] == NSOrderedSame)
	{
		if(self.mCircleSave == nil)
		{
			self.mCircleSave = [UIImage imageNamed:imageName];
		}
		circleImage = self.mCircleSave;
	}
	
	return circleImage;
}

-(void)setPresetUseImageForDevice
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		self.mPresetReviewImageName			= @"preset_review_iPad.png";
		self.mPresetReviewMaskImageName		= @"preset_review_mask_iPad.png";
		self.mPresetReviewMaskSelImageName	= @"preset_review_mask_sel_iPad.png";
	}
	else
	{
		BOOL isIphone4 = YES;//[self checkIfiPhone4]; //这个地方使用高清的图片做渲染，然后缩放1／2使用，注释掉了，暂时不要改回来
		if(isIphone4)
		{
			self.mPresetReviewImageName			= @"preset_review_4.png";
			self.mPresetReviewMaskImageName		= @"preset_review_mask_4.png";
			self.mPresetReviewMaskSelImageName	= @"preset_review_mask_sel_4.png";
		}
		else
		{
			self.mPresetReviewImageName			= @"preset_review.png";
			self.mPresetReviewMaskImageName		= @"preset_review_mask.png";
			self.mPresetReviewMaskSelImageName	= @"preset_review_mask_sel.png";
		}
	}
}
-(BOOL)checkIfiPhone4
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
	NSRange rangeIPod4 = [machine rangeOfString:@"iPod4"];
	if(rangeIPod4.length != 0)
	{
		return YES;
	}
	
	return NO;
}

-(BOOL)checkIfTallScreen
{
    int height = [[ UIScreen mainScreen ] bounds ].size.height;
//    int width  = [[ UIScreen mainScreen ] bounds ].size.width;
    
    return  ( fabs( ( double ) height - ( double )568 ) < DBL_EPSILON );
}

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

-(void)checkTheVersionAndMoveThePresetPlist
{
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString *lastVersion = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
	
	if(lastVersion != nil && [lastVersion compare:version] == NSOrderedSame) return;
	
	//remove the old plist
	[[RConfigFile sharedConfig] DeleteConfigFileForName:presets_plist_current];
	[[RConfigFile sharedConfig] DeleteConfigFileForName:presets_plist_default];
	
	//move plist to document
	[[RConfigFile sharedConfig] MoveBundleFileToDocument:presets_plist_current];
	[[RConfigFile sharedConfig] MoveBundleFileToDocument:presets_plist_default];
	
}
-(void)startWait
{
	self.savingMaskView.hidden = NO;
	self.savingSpinner.hidden = NO;
	[self.savingSpinner startAnimating];
}
-(void)stopWait
{
	[self.savingSpinner stopAnimating];
	self.savingSpinner.hidden = YES;
	self.savingMaskView.hidden = YES;
}
-(void)initUsedPropertiesAndUIForOriginPhoto:(UIImage*)originPhoto
{
	[NSThread detachNewThreadSelector:@selector(startWait) toTarget:self withObject:nil];
	
	
	//注意：调用这个函数之前，必须保证self.preset已经初始化过了
	//选取photo view rect
    // "Note: Before calling this function, you must ensure that self.preset already initialized the selected photo view rect"  (via Google Translate)
	CGRect photoViewRect = photo_view_rect;
    if (IS_IPHONE_5)
        photoViewRect = photo_view_rect_iphone5;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		photoViewRect = photo_view_rect_ipad;
	}
	
	
	//save the orientation
	_sourceOrientation = originPhoto.imageOrientation;
	
	
	//限制一下图片的大小，如果过大，就裁剪到合适的尺寸
    // "Click image size restrictions, if too large, cut to the appropriate size"  (via Google Translate)
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
	// NOTE: Why are we limiting the render to a fixed pixel dimension depending on runtime device?
    // 6/2013 - Charles Ruggiero, Red Conductor
    //
    // This causes several problems:
    // A) You cannot possibly maintain source code to handle all future iOS devices and their camera capabilities.
    // For example, what about the iPhone 5 and iPod Touch 5th gen (2012) with their 4-inch displays?
    //
    // B) Furthermore modern iOS devices have two cameras with varying capture resolutions.  Thus the device's screen size
    // has no coorelation to the max pixel resolution of the image the device can capture.
    //
    // C) Photos library (AVAssetsLibrary) can easily contain images that were not generated on the device (sync'ed from
    // home computer or downloaded from the web), therefore limiting pixels based on the runtime device is
    // useless for the original **source** photo.
    //
    // Yes, limits are reasonable for the adjustment photo when used within the UI, but not for the final render to disk.
    //
    // Will delay removing the above limitPixel calculations and constants once it is determined this bug is verified as closed.
    //
    //originPhoto = [self limitedSourcePhoto:originPhoto forLimitPixel:limitPixel];
    //
	
	
	//save the source photo
	self.sourcePhoto = originPhoto;

	
	//calculate the render Rect
    CGRect photoPlaceRect = [self photoRenderRectForImageSize:originPhoto.size withImageViewRect:photoViewRect];
	
	//got self.photo
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		//self.photo = [self imageWithImage:originPhoto scaledToSize:CGSizeMake(photoPlaceRect.size.width/2, photoPlaceRect.size.height/2)];
		self.photo = [self imageWithImage:originPhoto scaledToSize:CGSizeMake(photoPlaceRect.size.width*1.2, photoPlaceRect.size.height*1.2) renderedForUI:NO];

	}
	else 
	{
		//self.photo = [self imageWithImage:originPhoto scaledToSize:CGSizeMake(photoPlaceRect.size.width, photoPlaceRect.size.height)];
		if ([self checkIfiPhone4] == YES) {
//            CGSize photoSize = CGSizeMake(photoPlaceRect.size.width*2, photoPlaceRect.size.height*2);            
			self.photo = [self imageWithImage:originPhoto scaledToSize:CGSizeMake(photoPlaceRect.size.width*2, photoPlaceRect.size.height*2) renderedForUI:NO];
 
		} else {
			self.photo = [self imageWithImage:originPhoto scaledToSize:CGSizeMake(photoPlaceRect.size.width*1.2, photoPlaceRect.size.height*1.2) renderedForUI:NO];
		}
	}
	//self.photo = [self imageWithImage:originPhoto scaledToSize:CGSizeMake(photoPlaceRect.size.width, photoPlaceRect.size.height)];

//    CGSize imageSize = self.photo.size;
	
	// NOTE: Why are we rotating the source image depending on runtime device?
    // 6/2013 - Charles Ruggiero, Red Conductor
    //
    // However, skipping this rotation here, causes the final render to disk to not be rotated properly for portrait photos?
    // And some landscape images to be mirrored on output!  Will delay this change until more investigation is done.
    //
	//rotate photo to fit
    
	//add alpha
	self.photo = [self imageAddAlphaForImage:self.photo];
	
	
	//got photo renderRect
	_photoRenderRect = [self photoRenderRectForImageSize:self.photo.size withImageViewRect:photoViewRect];
	
	
	//render the photo
	//	[self renderPhotoViewForPreset:self.preset useImage:self.photo changeType:typeNone actioning:NO];
	
	
	//set vignette position
	//	Parameter *param = [self parameterWithPreset:self.preset];
	//	[_vignetteView setVignetteForParam:param photoRect:_photoRenderRect];
	
	
	//make out the adjustPhoto
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		self.adjustPhoto = [self imageWithImage:self.photo scaledToSize:CGSizeMake(self.photo.size.width/2,self.photo.size.height/2) renderedForUI:YES];
	}
	else 
	{
		self.adjustPhoto = [self imageWithImage:self.photo scaledToSize:CGSizeMake(self.photo.size.width/2,self.photo.size.height/2) renderedForUI:YES];
	}
	self.adjustPhoto = [self imageAddAlphaForImage:self.adjustPhoto];
	
	
	//set vignette position
	Parameter *param = [self parameterWithPreset:self.preset];
	[_vignetteView setVignetteForParam:param photoRect:_photoRenderRect];
	
	
	[self stopWait];
}
-(void)saveOriginPhoto:(UIImage*)image
{
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	NSString *filePath = [NSHomeDirectory() stringByAppendingString:save_origin_photo_path];
	[imageData writeToFile:filePath atomically:YES];
	
	_bSavingOriginPhoto = NO;
}
-(UIImage*)loadPhotoFromPath:(NSString*)path
{
	NSString *filePath = [NSHomeDirectory() stringByAppendingString:path];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return nil;
	
	UIImage* orinPhoto = [UIImage imageWithContentsOfFile:filePath];
	return orinPhoto;
}
-(void)changeTintMaskForIndex:(NSInteger)index
{
	NSString *tintMaskName = [NSString stringWithFormat:@"tint_mask_%zd.png", index];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		tintMaskName = [NSString stringWithFormat:@"tint_mask_iPad_%zd.png", index];
	}
	
	self.tintMaskView.image = [UIImage imageNamed:tintMaskName];
}
-(UIImage*)limitedSourcePhoto:(UIImage*)source forLimitPixel:(float)limit
{
	CGSize sourceSize = source.size;
//	if(sourceSize.width >= sourceSize.height)
//	{
//		if(sourceSize.width <= limit)
//		{
//			return source;
//		}
//	}
//	else
//	{
//		if(sourceSize.height <= limit)
//		{
//			return source;
//		}
//	}
	
	//baiwei add for small image keeping original size
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
    // "Find stint can be scaled to the rect" (via Google Translate)
	CGRect limitedRect = [self photoRenderRectForImageSize:sourceSize withImageViewRect:CGRectMake(0.0, 0.0, limit, limit)];
	
	//把图片缩放到限制以后的大小
    // "After the picture zoom to limit the size of" (via Google Translate)
	UIImage *limitedImage = [self imageWithImage:source scaledToSize:limitedRect.size renderedForUI:NO]; //autorelease
	
	//给缩放以后的图片增加alpha
    // "After scaling the picture to increase alpha" (via Google Translate) 
	UIImage *alphaLimitedImage = [self imageAddAlphaForImage:limitedImage]; //autorelease

	return alphaLimitedImage;
}




#pragma mark -
#pragma mark in use functios @for Rendering
- (UIImage*)genVignetteImg:(UIImage*)_sourceImg renderArgs:(ffRenderArguments)renderArgs
{	
	if(_sourceImg == nil) return nil;
	
	CGFloat width = CGImageGetWidth(_sourceImg.CGImage);
	CGFloat height = CGImageGetHeight(_sourceImg.CGImage);
	
	CGPoint point = renderArgs.ellipse_center;
	CGPoint centre = point;
	
	centre.x = width/2.0 * (1.0 + point.x);
	centre.y = height/2.0 * (1.0 + point.y);
	
	// Find absolute translation
	//
	point.x *= width/2.0;
	point.y *= height/2.0;
	
	int rowbytes = width*4;	
	unsigned char *buffer = (unsigned char*)malloc( height * rowbytes );
	if(buffer == nil) 
		return nil;
	
	//CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(_sourceImg.CGImage);
	CGContextRef context = CGBitmapContextCreate(buffer, 
												 width, 
												 height, 
												 8, 
												 rowbytes, 
												 CGColorSpaceCreateDeviceRGB(), 
												 1
												 );
	
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, width, height));
	CGContextSetInterpolationQuality(context,kCGInterpolationHigh);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformTranslate(transform, centre.x, centre.y);
	transform = CGAffineTransformRotate(transform, renderArgs.ellipse_angle);
	transform = CGAffineTransformScale(transform,1.0*renderArgs.ellipse_a,1.0*renderArgs.ellipse_b);
	transform = CGAffineTransformTranslate(transform, -centre.x, -centre.y);
	
	UIImage *art = [self circleImageForName:self.mCircleImageName];//[UIImage imageNamed:self.mCircleImageName]; //@"circle.png
	
	CGContextConcatCTM(context, transform);
	
	//	CGColorRef colors[2];
	//	CGFloat white[4] = {255, 255, 255, 255};
	//	CGFloat black[4] = {0, 0, 0, 255};
	//	CGFloat locations[2] = {0, 1};
	//	colors[0] = CGColorCreate (CGColorSpaceCreateDeviceRGB(), white);
	//	colors[1] = CGColorCreate (CGColorSpaceCreateDeviceRGB(), black);
	//	CFArrayRef arrayRef = CFArrayCreate( NULL, colors, 2, NULL);
	//	CGGradientRef grad = CGGradientCreateWithColors( NULL, colors, locations );
	//	CGContextDrawRadialGradient(context, grad, CGPointMake(width/2,height/2), 0.0, CGPointMake(width/2,height/2), 0.5*height, kCGGradientDrawsAfterEndLocation);
    CGContextDrawImage(context, CGRectMake(point.x, point.y, width, height), art.CGImage);
	CGImageRef newImageRef = CGBitmapContextCreateImage(context);
	
	// get the UIImage back	
	UIImage* newImage = [[UIImage alloc] initWithCGImage:newImageRef];
	CGImageRelease(newImageRef);	
	CGContextRelease(context);
	free(buffer);
	return newImage;
}

//Rec709
//#define sat_coef_709_r 0.2126
//#define sat_coef_709_g 0.7152
//#define sat_coef_709_b 0.0722
//#define sat_coef_709_r 54
//#define sat_coef_709_g 182
//#define sat_coef_709_b 19

//r = 0.5174
//g = 0.4274
//b = 0.0552
#define sat_coef_r 33908
#define sat_coef_g 28010
#define sat_coef_b 3617


#define CUBED (6.0308629e-08)
- (UIImage *)noirSourceImg:(UIImage *)_sourceImg renderArgs:(ffRenderArguments)renderArgs
{
	if(_sourceImg == nil) return nil;
	
	CGFloat _width = CGImageGetWidth(_sourceImg.CGImage);
	CGFloat _height = CGImageGetHeight(_sourceImg.CGImage);
	CFDataRef sourceData = CGDataProviderCopyData(CGImageGetDataProvider(_sourceImg.CGImage));
	int *m_sourcedata = (int *)CFDataGetBytePtr(sourceData);
	uint8_t *sourceb = (unsigned char *)&m_sourcedata[0];
	
	// Prepare inGain LUT
	//
	int inGain_i = (int) fabs(255 * (renderArgs.inExp * 0.25));
	int inGain[256];
	if ( renderArgs.inExp > 0.0 )
	{
		for (int r=0; r<256; r++)
		{
			inGain[r] = (briteLUT[r] * inGain_i + (255 - inGain_i) * r)/255;
		}
	}
	else
	{
		for (int r=0; r<256; r++)
		{
			inGain[r] = (darkLUT[r] * inGain_i + (255 - inGain_i) * r)/255;
		}
	}
	
	// Prepare outGain LUT
	//
	int outGain_i = (int) fabs(255 * (renderArgs.outExp  * 0.25));
	int outGain[256];
	if ( renderArgs.outExp > 0.0 )
	{
		for (int r=0; r<256; r++)
		{
			outGain[r] = (briteLUT[r] * outGain_i + (255 - outGain_i) * r)/255;
		}
	}
	else
	{
		for (int r=0; r<256; r++)
		{
			outGain[r] = (darkLUT[r] * outGain_i + (255 - outGain_i) * r)/255;
		}
	}					 
	
	//	double inGain = pow(pow(2.0, renderArgs.inExp), 1/2.2);
	//	double outGain = pow(pow(2.0, renderArgs.outExp), 1/2.2);
	//	double gain[256];
	//	for (int r=0; r<256; r++)
	//	{
	//		gain[r] = (inGain * r + outGain * (255-r)) / 255.0;
	//	}
	
	// Prepare contrast s-curve LUT
	//
	int clamp[256];
	int i, tempInt;
	double pivot = 0.5;
	for (i=0; i<128; i++)
	{
		tempInt = 255 *pow(i/(pivot*255),renderArgs.noir_contrast) * pivot;
		if (tempInt<0) clamp[i]=0;
		else if (tempInt>255) clamp[i] = 255;
		else clamp[i] = tempInt;
	}
	for (;i<256; i++)
	{
		tempInt = 255 * pow((i - 255)/(pivot*255 - 255),renderArgs.noir_contrast) * (pivot - 1.0f) + 255;
		if (tempInt<0) clamp[i]=0;
		else if (tempInt>255) clamp[i] = 255;
		else clamp[i] = tempInt;
	}	
	
	// Prepare the 2-D LUT for blending source and vignette  (source=p; vigette=q)
	//
	int c, m;
//	uint8_t noir[256][256];
//	for (int p=0; p<256; p++)
//	{
//		for (int q=0; q<256; q++)
//		{
//			//			c = p * gain[q];
//			c = (inGain[p] * q + outGain[p] * (255 - q)) / 255;
//			if ( c<0 ) c=0;
//			if ( c>255 ) c=255;
//			
//			// Contrast
//			//
//			c = clamp[c];
//			noir[p][q] = (unsigned char) c;
//		}
//	}
	
	// Prepare for output buffer
	uint8_t *pout, *poutb;
	pout = poutb = (uint8_t *)malloc(_width * _height * 4);
    if (!pout)
	{
		CFRelease(sourceData);
		return nil;
	}
	
	UIImage *matte = [self genVignetteImg:_sourceImg renderArgs:renderArgs ];
	
	CFDataRef matteData = CGDataProviderCopyData(CGImageGetDataProvider(matte.CGImage));
	int *m_mattedata = (int *)CFDataGetBytePtr(matteData);
	uint8_t *matteb = (unsigned char *)&m_mattedata[0];
    for (int y = 0; y < _height; y++) 
	{  
		for (int x = 0; x < _width; x++) 
		{  
			c = (*sourceb * sat_coef_r + *(sourceb+1) * sat_coef_g + *(sourceb+2) * sat_coef_b) / 65535;
			if (c > 255) c = 255;
			
			m = ((*matteb << 16) + (*(matteb+1) << 8) + *(matteb+2))>>1;
			c = (inGain[c] * m + outGain[c] * (8388607 - m)) / 8388607;
			if ( c<0 ) c=0;
			if ( c>255 ) c=255;
			c = clamp[c];

			//c = noir[c][*matteb];
			
			*pout++ = (unsigned char) c;
			*pout++ = (unsigned char) c;
			*pout++ = (unsigned char) c;
			*pout++ = (unsigned char) 255;
			
			sourceb += 4;
			matteb += 4;
		}
	}
	
	
	CFRelease(sourceData);
	CFRelease(matteData);
	
	CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
	//CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(_sourceImg.CGImage);
	CGContextRef context=CGBitmapContextCreate(poutb, _width, _height, 8, _width*4, colorSpace, 1);	
	CGImageRef imageRef=CGBitmapContextCreateImage(context);
	free(poutb);  
	
	UIImage* newImage2 = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	// Tinting
	//
//@Radar + -----
	
//	UIGraphicsBeginImageContext(CGSizeMake(_width,_height));
//	context = UIGraphicsGetCurrentContext();
	
//	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, CGRectMake(0.0, 0.0, _width, _height));
	
	
	//[newImage2 drawAtPoint:CGPointMake(0,0)];
	//[newImage2 release];		
//@Radar - -----

	
	//@Radar + -----
	UInt8* buffer = (UInt8*)malloc(_width * _height * 4);	
	CGColorSpaceRef	desColorSpace = CGColorSpaceCreateDeviceRGB();
	context = CGBitmapContextCreate(buffer,
									_width,_height,
									8, 4*_width,
									desColorSpace,
									1);
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, (CGFloat)_width, (CGFloat)_height), newImage2.CGImage);
	//@Radar - -----
	
	
	CGContextSetBlendMode(context,kCGBlendModeColor);
	
	switch (renderArgs.tint)
	{
		case 2:
			CGContextSetRGBFillColor(context, 0.83137255, 0.91372549, 1.0, 1.0);	// Silver
			CGContextFillRect(context, CGRectMake(0,0,_width,_height));
			break;
		case 3:
			CGContextSetRGBFillColor(context, 0.91764706, 1.0, 0.87843137, 1.0);	// Emerald
			CGContextFillRect(context, CGRectMake(0,0,_width,_height));
			break;
		case 0:
			CGContextSetRGBFillColor(context, 1.0, 0.92941176, 0.83137255, 1.0);	// Sepia
			CGContextFillRect(context, CGRectMake(0,0,_width,_height));
			break;
		default:
			break;
	}
	CGImageRef imageRef2=CGBitmapContextCreateImage(context);
	UIGraphicsEndImageContext();
	
	UIImage* newImage = [[UIImage alloc] initWithCGImage:imageRef2];
	CGImageRelease(imageRef2);
	
	
	CGContextRelease(context);
	CGColorSpaceRelease(desColorSpace);
	
	free(buffer);
	
    return newImage;
}
-(UIImage*)renderForArguments:(ffRenderArguments)renderArgs useImage:(UIImage*)image changeType:(ChangeType)changeType
{	
	//TO DO: Rendering for preset
	UIImage *renImage = [self noirSourceImg:image renderArgs:renderArgs];
	return renImage;
}

-(NSArray*)tintsInitialization
{
	//TO DO: initialize the Tints
    NSMutableArray *allTints = [[NSMutableArray alloc] initWithCapacity:4];
	for(int i=0; i<4; i++)
	{
        Tint *tint = [[Tint alloc] init];
		tint.index = i;
		//tint.color = [UIColor blueColor];
		
		[allTints addObject:tint];
	}
	return allTints;
}




#pragma mark -
#pragma mark out use functions
-(void)savePresetToUserDefault
{
	if(self.preset == nil) return;
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.preset.index] forKey:@"save_preset_index"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.expInside] forKey:@"save_preset_expInside"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.expOutside] forKey:@"save_preset_expOutside"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.contrast] forKey:@"save_preset_contrast"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.preset.tintIndex] forKey:@"save_preset_tintIndex"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.ellipseCenterX] forKey:@"save_preset_ellipseCenterX"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.ellipseCenterY] forKey:@"save_preset_ellipseCenterY"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.ellipseA] forKey:@"save_preset_ellipseA"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.ellipseB] forKey:@"save_preset_ellipseB"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.preset.ellipseAngle] forKey:@"save_preset_ellipseAngle"];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
-(Preset*)presetFromUserDefault
{
	NSNumber *save_preset_index = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_index"];
	NSNumber *save_preset_expInside = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_expInside"];
	NSNumber *save_preset_expOutside = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_expOutside"];
	NSNumber *save_preset_contrast = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_contrast"];
	NSNumber *save_preset_tintIndex = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_tintIndex"];
	NSNumber *save_preset_ellipseCenterX = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_ellipseCenterX"];
	NSNumber *save_preset_ellipseCenterY = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_ellipseCenterY"];
	NSNumber *save_preset_ellipseA = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_ellipseA"];
	NSNumber *save_preset_ellipseB = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_ellipseB"];
	NSNumber *save_preset_ellipseAngle = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_preset_ellipseAngle"];
	
	if(save_preset_index == nil) return nil;
	
	
    Preset *apreset = [[Preset alloc] init];
	apreset.index = [save_preset_index intValue];
	apreset.expInside = [save_preset_expInside floatValue];
	apreset.expOutside = [save_preset_expOutside floatValue];
	apreset.contrast = [save_preset_contrast floatValue];
	apreset.tintIndex = [save_preset_tintIndex intValue];
	apreset.ellipseCenterX = [save_preset_ellipseCenterX floatValue];
	apreset.ellipseCenterY = [save_preset_ellipseCenterY floatValue];
	apreset.ellipseA = [save_preset_ellipseA floatValue];
	apreset.ellipseB = [save_preset_ellipseB floatValue];
	apreset.ellipseAngle = [save_preset_ellipseAngle floatValue];
	
	return apreset;
}



@end
