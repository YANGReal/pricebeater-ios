//
//  GoodsListViewController.h
//  PBScanner
//
//  Created by YANGReal on 14-3-5.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListViewController : PBBaseViewController
@property (strong , nonatomic) NSArray *dataArray;
@property (copy , nonatomic) NSString *keyword;

@end
