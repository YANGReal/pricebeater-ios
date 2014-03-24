//
//  GoodDetailViewController.h
//  PBScanner
//
//  Created by YANGReal on 14-3-8.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBBaseViewController.h"

@interface GoodDetailViewController : PBBaseViewController

@property (copy , nonatomic) NSString *urlString;

@property (copy , nonatomic) NSString *historyURL;

@property (assign , nonatomic) int type;

@property (strong , nonatomic) NSArray *dataArray;

@property (assign , nonatomic) int currentIndex;

@end
