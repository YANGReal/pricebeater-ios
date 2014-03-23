//
//  MainViewController.h
//  PBScanner
//
//  Created by YANGReal on 14-2-26.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMainViewController : UITabBarController

@property (assign , nonatomic) BOOL showTabBar;

- (void)hideTabBarWithType:(int)type;
- (void)revealTabBarWithType:(int)type;

- (void)highLightedFirstTabBarItem;
@end
