//
//  CrashlyticsBridge.m
//  NoirPhoto
//
//  Created by Sean Hess on 5/16/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

#import "CrashlyticsBridge.h"
#import <Crashlytics/Crashlytics.h>

@implementation CrashlyticsBridge

+ (void)log:(NSString *)message {
    CLS_LOG(@"%@", message);
}

@end