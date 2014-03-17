//
//  GoodsListViewController.h
//  PBScanner
//
//  Created by YANGReal on 14-3-5.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsListViewController;
@protocol GoodsListViewControllerDelagate <NSObject>

@optional
- (void)backFromGoodsListViewController:(GoodsListViewController *)vc;

@end

@interface GoodsListViewController : PBBaseViewController
@property (strong , nonatomic) NSArray *dataArray;
@property (copy , nonatomic) NSString *keyword;

@property (assign , nonatomic) id<GoodsListViewControllerDelagate>delagate;

@end
