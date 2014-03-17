//
//  ScanDetailViewController.h
//  PBScanner
//
//  Created by YANGReal on 14-3-9.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

typedef enum
{
    barCodeType,
    priceTagType
} ScanType;

@class ScanDetailViewController;
@protocol ScanDetailViewControllerDelegate <NSObject>

@optional
- (void)backFromScanDetailViewController:(ScanDetailViewController *)vc;

@end

#import <UIKit/UIKit.h>

@interface ScanDetailViewController : PBBaseViewController

@property (assign , nonatomic) id<ScanDetailViewControllerDelegate>delegate;

@property (assign , nonatomic) ScanType scanType;
@end
