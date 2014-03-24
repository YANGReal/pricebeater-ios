//
//  LocationViewController.h
//  PBScanner
//
//  Created by YANGReal on 14-3-2.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationViewControllerDelegate <NSObject>

@optional

- (void)backFromLocationViewControllerWithLocation:(NSString *)location;

@end

@interface LocationViewController : PBBaseViewController
@property (assign , nonatomic) id<LocationViewControllerDelegate>delegate;
@end
