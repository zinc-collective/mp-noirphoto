//
//  RScrollView.h
//  Noir
//
//  Created by mac on 11-1-7.
//  Copyright 2019 Zinc Collective, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@class RScrollView;
@protocol RScrollViewDelegate <NSObject>
@optional
-(void)rScrollViewDidDoubleClick;
@end


@interface RScrollView : UIScrollView {
}

@property (nonatomic, weak) id<RScrollViewDelegate> rdelegate;

@end
