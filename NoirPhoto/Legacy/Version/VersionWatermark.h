//
//  VersionWatermark.h
//  FlickrPlug
//
//  Created by jack on 10-4-20.
//  Copyright 2009 RED/SAFI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionWatermark : UIView {
	
	UILabel			*_version;

}

- (void) showInView:(UIView*)view;
- (void) loadingVersion;

@end


