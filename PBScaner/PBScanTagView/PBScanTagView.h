//
//  PBScanTagView.h
//  PBScanner
//
//  Created by YANGReal on 14-3-9.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PBScanTagViewDelegate <NSObject>

@optional

- (void)pbScanTagViewStartProcessImage:(UIImage *)image;

- (void)pbScanTagViewDidOutputResult:(NSString *)result;

@end

@interface PBScanTagView : UIView
@property (assign,nonatomic) id<PBScanTagViewDelegate>delegate;
- (void)startScan;
- (void)stopScan;

/*移除Observer*/
- (void)free;
@end
