//
//  CrashlyticsBridge.h
//  NoirPhoto
//
//  Created by Sean Hess on 5/16/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashlyticsBridge : NSObject

+ (void)log:(NSString *)message;

@end