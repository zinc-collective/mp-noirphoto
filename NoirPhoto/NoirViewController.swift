//
//  NoirScaleHackViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit

// scales up the whole view, just like if we weren't supporting iPhone 6 or 6+
class NoirViewController: NoirViewControllerLegacy {
    
    // SCALE HACK: remove me once we change the UI
    override func viewWillAppear(animated: Bool) {
        if (UI_USER_INTERFACE_IDIOM() == .Phone) {
            let scale = self.view.frame.size.width / CGFloat(320)
            self.view.transform = CGAffineTransformMakeScale(scale, scale)
            super.viewWillAppear(animated)
        }
    }
    
    @IBAction func onTapShare() {
        print("SHARE")
        // I need to render it, but not save...
        let photo = self.renderPhoto()
        
        let activity = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
    }
    
    func renderPhoto() -> UIImage {
    	print("save time self.sourcePhoto: ", self.sourcePhoto.size.width, self.sourcePhoto.size.height)
        
        // TODO: what does this do?
    	self.mCircleImageName = self.circleImageNameForState(0) //@"circle.png";
    	
        //注释掉，保留，这个地方是在保存之前对图片做旋转处理一下
        //	//rotate source photo to fit
        //	UIImage *fitPhoto = [self rotatePhotoToFit:self.sourcePhoto withOriatation:_sourceOrientation];
        //	
        //	//render the photo
        //	UIImage *renderPhoto = [self imageForPreset:self.preset useImage:fitPhoto];
        //	
        //	//rotate render photo to original
        //	UIImage *savePhoto = [self rotatePhotoToOriginal:renderPhoto originOriatation:_sourceOrientation];

        var savePhoto : UIImage
    	
    	if(UI_USER_INTERFACE_IDIOM() == .Pad)
    	{
    		//render the photo
    		savePhoto = self.imageForPreset(self.preset, useImage: self.sourcePhoto)
    	}
    	else
    	{

            // TODO What is this for?
            if (_bPhotoRotated /*|| _sourceOrientation == UIImageOrientationDown*/ ) {
                
                //rotate source photo to fit
                let fitPhoto = self.rotatePhotoToFit(self.sourcePhoto, withOriatation: _sourceOrientation)
                
                //render the photo
                let renderPhoto = self.imageForPreset(self.preset, useImage: fitPhoto)
                
                //rotate render photo to original
                savePhoto = self.rotatePhotoToOriginal(renderPhoto, originOriatation: _sourceOrientation)
            
            } else {
                
                savePhoto = self.imageForPreset(self.preset, useImage: self.sourcePhoto)
                
            }
    	}
        
        return savePhoto


//    	//save the photo
//    	//UIImageWriteToSavedPhotosAlbum(savePhoto, nil, nil, nil); 
//    	
//    	//save the photo
//    	NSLog(@"saveImageMetadata=%@", imageMetadata);
//    	if (imageMetadata == nil) {
//    		UIImageWriteToSavedPhotosAlbum(savePhoto, nil, nil, nil); 
//    	} else {
//    		[imageMetadata setObject:[NSNumber numberWithInteger:savePhoto.imageOrientation] forKey:@"Orientation"];
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    		
//    		CGImageRef imageMetadataRef=savePhoto.CGImage;
//    		
//    		[library writeImageToSavedPhotosAlbum:imageMetadataRef metadata:imageMetadata completionBlock:^(NSURL *newURL, NSError *error) {
//    			if (error) {
//    			} else {
//    			}
//    		}];
//    	}
    }
    
    
////UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//	if(buttonIndex == 1) //save
//	{
//		[NSThread detachNewThreadSelector:@selector(startWait) toTarget:self withObject:nil];
//		
//		[self renderAndSavePhoto];
//		
//		[self stopWait];
//		
//		[self loadAction:self.loadBtn];
//    }
//}
}
