//
//  PBScanner.h
//  PBScanner
//
//  Created by YANGReal on 14-3-9.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PBScannerViewDelegate <NSObject>

@optional

- (void)pbScannerViewDidOutputResult:(NSString *)result;

@end


@interface PBScannerView : UIView


@property (assign , nonatomic) id<PBScannerViewDelegate>delegate;
- (void)startScan;

- (void)stopScan;

@end
