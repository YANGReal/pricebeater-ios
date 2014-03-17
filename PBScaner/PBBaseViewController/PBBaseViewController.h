//
//  YRBaseViewController.h
//  PBScanner
//
//  Created by YANGReal on 14-2-26.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBBaseViewController : UIViewController


/*用于提示信息*/
-(void)showMBLoadingWithMessage:(NSString *)message;

/*用于隐藏提示信息*/
-(void)hideMBLoading;

/*操作失败提示信息*/
-(void)showMBFailedWithMessage:(NSString *)message;
@end
