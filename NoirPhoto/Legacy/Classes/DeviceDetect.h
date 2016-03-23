//
//  DeviceDetect.h
//  MobileLooks
//
//  Created by Bret Timmins on 10/23/13
//
#ifndef __DEVICE_DETECT_H__
#define __DEVICE_DETECT_H__

//note: if Default-568h@2x.png is not including in build, iphone screen size will be 320 x 480 on iphone 5
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)
#define IPHONE_SCALE_HEIGHT 480.0f //568.0f

#endif //__DEVICE_DETECT_H__

