//
//  ShareView.h
//  PBScanner
//
//  Created by YANGReal on 14-3-8.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareView;
@protocol ShareViewDelegate <NSObject>

@optional
- (void)shareView:(ShareView *)shareView didSelectAtIndex:(int)index;

@end

@interface ShareView : UIView
@property (assign , nonatomic) id<ShareViewDelegate>delegate;

@end
