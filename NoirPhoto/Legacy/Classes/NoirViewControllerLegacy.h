//
//  NoirViewController.h
//  Noir
//
//  Created by jack on 6/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ControlPadView.h"
#import "Preset.h"
#import "Tint.h"
#import "VignetteView.h"
#import "Parameter.h"



typedef enum
{
	typeNone,
	typePreset,
	typeTint,
	typeAdjust,
	typeVignette
} ChangeType;


typedef struct {
	double inExp;
	double outExp;
	double noir_contrast;
	CGPoint ellipse_center;
	double ellipse_a;
	double ellipse_b;
	double ellipse_angle;
	int tint;
} ffRenderArguments;




//@class QuartzView;
@interface NoirViewControllerLegacy : UIViewController <UIPopoverControllerDelegate, VignetteDelegate, ControlPadViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	UIImageView			 *photoView;
	UIImageView			 *photoFullView;
	
	UIImage              *photo;       //the photo used to render
	UIImage				 *adjustPhoto; //photo for the adjust change only
	UIImage				 *renderedPhoto; //the photo rendered
	UIImage              *sourcePhoto;
	
	//QuartzView           *_ellipseView;
	VignetteView		 *_vignetteView;
	VignetteView		 *_vignetteFullView;
	ControlPadView       *_ctrlPadView;
	
	Preset				 *preset;      //current preset
	
	NSArray              *presetsItems; //not the NSArray of Preset but of Dictionary
	NSInteger            presetsChooseIndex;
	
	NSArray              *tints;
	NSArray              *tintsItems;   //not the NSArray of Tint but of Dictionary
	
	IBOutlet UIButton			 *loadBtn;
	IBOutlet UIButton			 *saveBtn;
	IBOutlet UIButton			 *infoBtn;
	IBOutlet UIImageView		 *tintMaskView;
	
	CGRect               _photoRenderRect;  //是一个相对值，相对于photo view的 rect值，原点也是相对于photoview的位置
		CGRect               _photoRenderRect2;
	
	
	NSString             *mCircleImageName;
	NSString			 *mPresetReviewImageName;
	NSString			 *mPresetReviewMaskImageName;
	NSString			 *mPresetReviewMaskSelImageName;
	
	UIView						*savingMaskView;
	UIActivityIndicatorView		*savingSpinner;
	
	BOOL				 _bRendering;
	
	UIImage				 *mCirclePreset;
	UIImage				 *mCirclePreset4;
	UIImage				 *mCircleShow;
	UIImage				 *mCircleShow4;
	UIImage				 *mCircleRender;
	UIImage				 *mCircleSave;
	
	BOOL				 _bPreseting;  //是否正处于preset状态下，只要任何一个操作更改，都不再处于preset状态
	
	UIPopoverController *imagePickerPopover;
	UIImagePickerController *imagePicker;
    BOOL imagePickerOnScreen; //bret
	
	UIButton *fullBtn;
	
	UIView *blackBackground;
	
	NSMutableDictionary *imageMetadata;
	
	int isFull;
	float ctrl_pad_offset;
	
	BOOL                 _bSavingOriginPhoto;
}

@property (nonatomic, retain) UIImageView    *photoView;
@property (nonatomic, retain) UIImageView    *photoFullView;
@property (nonatomic, retain) UIImage        *photo;
@property (nonatomic, retain) UIImage		 *adjustPhoto;
@property (nonatomic, retain) UIImage		 *renderedPhoto;
@property (nonatomic, retain) UIImage        *sourcePhoto;
@property (nonatomic, retain) Preset         *preset;
@property (nonatomic, retain) NSArray        *presetsItems;
@property (nonatomic)         NSInteger      presetsChooseIndex;
@property (nonatomic, retain) NSArray        *tints;
@property (nonatomic, retain) NSArray        *tintsItems;
@property (nonatomic, retain) UIButton		 *loadBtn;
@property (nonatomic, retain) UIButton		 *saveBtn;
@property (nonatomic, retain) UIButton	     *infoBtn;
@property (nonatomic, retain) UIImageView	 *tintMaskView;
@property (nonatomic, retain) NSString       *mCircleImageName;
@property (nonatomic, retain) NSString		 *mPresetReviewImageName;
@property (nonatomic, retain) NSString		 *mPresetReviewMaskImageName;
@property (nonatomic, retain) NSString		 *mPresetReviewMaskSelImageName;
@property (nonatomic, retain) UIView						*savingMaskView;
@property (nonatomic, retain) UIActivityIndicatorView		*savingSpinner;

@property (nonatomic, retain) UIImage				 *mCirclePreset;
@property (nonatomic, retain) UIImage				 *mCirclePreset4;
@property (nonatomic, retain) UIImage				 *mCircleShow;
@property (nonatomic, retain) UIImage				 *mCircleShow4;
@property (nonatomic, retain) UIImage				 *mCircleRender;
@property (nonatomic, retain) UIImage				 *mCircleSave;

@property (nonatomic, retain) UIPopoverController *imagePickerPopover;

@property (nonatomic, retain) VignetteView* _vignetteView;
@property (nonatomic, retain) VignetteView* _vignetteFullView;


@property (nonatomic) BOOL				 _bPhotoRotated;

@property (nonatomic) UIImageOrientation   _sourceOrientation;


#pragma mark -
#pragma mark in use functios @for UI
-(IBAction)loadAction:(id)sender;
-(IBAction)infoAction:(id)sender;

-(void)initElementsForControlPad; //only need to add presets and tints, the others will be add by controlpadview self

-(NSArray*)presetsItemsFromPlist:(NSString*)fileName;
-(void)saveToPlistForPresetItems:(NSArray*)presetItems;
-(Preset*)presetReadFromPlistByIndex:(NSInteger)index;
-(NSArray*)allPresetsReadFromPlist:(NSString*)fileName;

-(NSArray*)tintsItemsWithTints:(NSArray*)theTints;
-(NSInteger)chooseIndexForPresets:(NSArray*)presets;
-(void)setPresetsItemsChooseStateForIndex:(NSInteger)chooseIndex;
-(ffRenderArguments)argumentsWithPreset:(Preset*)apreset;
-(Parameter*)parameterWithPreset:(Preset*)aPreset;
-(void)renderPhotoViewForPreset:(Preset*)apreset useImage:(UIImage*)image changeType:(ChangeType)changeType actioning:(BOOL)bActioning;
-(void)threadRenderForArguments:(NSDictionary*)params;
-(UIImage*)imageForPreset:(Preset*)apreset useImage:(UIImage*)image;
-(UIImage*)imageCompiledForOriginImage:(UIImage*)originImage maskImage:(UIImage*)maskImage;
- (CGRect)photoRenderRectForImageSize:(CGSize)imageSize withImageViewRect:(CGRect)viewRect;
- (UIImage*)imageAddAlphaForImage:(UIImage*)image;
- (UIImage*)rotatePhotoToFit:(UIImage*)image withOriatation:(UIImageOrientation)orientation;
- (UIImage*)rotatePhotoToOriginal:(UIImage*)image originOriatation:(UIImageOrientation)orientation;


// Images that are elements of the user interface should be rendered at the device's
// native pixel density (non-retina vs retina). However, images selected by the user to be
// manipulated as part of the function of the application should be rendered at normal pixel density.
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize renderedForUI:(BOOL)usesDevicePixelDensity;

-(NSString*)circleImageNameForState:(NSInteger)state;
-(UIImage*)circleImageForName:(NSString*)imageName;
-(void)setPresetUseImageForDevice;
-(BOOL)checkIfiPhone4;					  //包含iPod4，也算
-(BOOL)checkIfPureiPhone4NotIncludeIPod4; //检查是否纯的iPhone4，不包括ipod4
-(void)checkTheVersionAndMoveThePresetPlist;
-(void)startWait;
-(void)stopWait;
-(void)initUsedPropertiesAndUIForOriginPhoto:(UIImage*)originPhoto;
-(void)saveOriginPhoto:(UIImage*)image;
-(UIImage*)loadPhotoFromPath:(NSString*)path;
-(void)changeTintMaskForIndex:(NSInteger)index;
-(UIImage*)limitedSourcePhoto:(UIImage*)source forLimitPixel:(float)limit; //限制原始图片的大小，并返回限制以后的图片

-(BOOL)checkIfTallScreen;
-(void)fullBtn:(id)sender;

#pragma mark -
#pragma mark in use functios @for Rendering
-(UIImage*)renderForArguments:(ffRenderArguments)renderArgs useImage:(UIImage*)image changeType:(ChangeType)changeType; //render for parameter
-(NSArray*)tintsInitialization;  //now only can support 4 tints
- (UIImage*)genVignetteImg:(UIImage*)_sourceImg renderArgs:(ffRenderArguments)renderArgs;
- (UIImage *)noirSourceImg:(UIImage *)_sourceImg renderArgs:(ffRenderArguments)renderArgs;



#pragma mark -
#pragma mark out use functions
-(void)savePresetToUserDefault;
-(Preset*)presetFromUserDefault;

#pragma mark Loading
-(void)pickPhoto:(NSURL*)assetURL image:(UIImage*)image;
-(void)loadWithSavedPhoto:(UIImage*)image;



@end

