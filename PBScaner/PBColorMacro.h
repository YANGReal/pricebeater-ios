//
//  PBColorMacro.h
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//


#ifndef PBScanner_PBColorMacro_h
#define PBScanner_PBColorMacro_h


/*导入头文件*/
#import "AppUtil.h"
#import "PBBaseViewController.h"
#import "UIView+ModifyFrame.h"
#import "AFNetworking.h"
#import "UIImage+WebP.h"
#import "RegexKitLite.h"
#import "NBNetworkEngine.h"
#import "NSDictionary+JSON.h"
#import "UIView+ModifyFrame.h"
#import "UIImage+Loader.h"
#import "UIView+Border.h"
#import "PBMainViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "AttributedLabel.h"
#pragma mark --定义常用宏


#define kRequestURL @"http://api.pricebeater.ca/app/v1/sku"
#define kShare_key @"14b15722862a"

#define SEARCH_URL(keyword) [NSString stringWithFormat:@"http://www.pricebeater.ca/search?q=%@&client=ios&client_version=1.0",keyword]

#define PRODUCT_DETAIL_URL(hash) [NSString stringWithFormat:@"http://www.pricebeater.ca/pm?urlhash=%@&client=ios&client_version=1.0",hash]

#define PRODUCT_HISTORY_URL(hash)  [NSString stringWithFormat:@"http://www.pricebeater.ca/pricehistory?urlhash=%@&client=ios&client_version=1.0",hash]


#define RECT(x,y,w,h) CGRectMake(x,y,w,h)

/*********************
 几何尺寸
 *********************/
#define ISIP5 ([UIScreen mainScreen].bounds.size.height == 568 ? YES : NO)
#define IP5ORIP4FRAME [UIScreen mainScreen].bounds.size.height == 568 ? CGRectMake(0.0, 0.0, 320.0, 568.0) : CGRectMake(0.0, 0.0, 320.0, 480.0)

#define POINT(x,y) CGPointMake(x,y)

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width

#define NAV_HEIGHT 64
#define TABBAR_HEIGHT 49


#pragma mark -- 定义APP沙盒路径
/******************************
 定义APP沙盒路径
 ******************************/
#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define TMPPATH NSTemporaryDirectory()
#define CACHPATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CACH_DOCUMENTS_PATH(fileName) [CACHPATH stringByAppendingPathComponent:fileName]//缓存文件路径
#define DOCUMENTS_PATH(fileName) [DOCUMENTPATH stringByAppendingPathComponent:fileName]//Documents文件夹路径

#pragma mark --定义日志输出
/******************************
 定义日志输出模式
 DLog is almost a drop-in replacement for NSLog
 DLog();
 DLog(@"here");
 DLog(@"value: %d", x);
 Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
 ******************************/
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#endif


#pragma mark - Function

#define COLOR_RGBA(r, g, b, a) [UIColor colorWithRed:((r) / 255.0f)    \
green:((g) / 255.0f)    \
blue:((b) / 255.0f)    \
alpha:((a) / 255.0f)]

#define COLOR_RGB(r, g, b) COLOR_RGBA(r, g, b, 0xFF)

#pragma mark - Color

#define COLOR_DEFAULT_GRAY      COLOR_RGB(0x49, 0x49, 0x49)
#define COLOR_DEFAULT_YELLOW    COLOR_RGB(0xFF, 0xBD, 0x02)

#define COLOR_NAVIGATION_BAR    COLOR_DEFAULT_GRAY
#define COLOR_NAVIGATION_TITLE  COLOR_DEFAULT_YELLOW
#define COLOR_TOOL_BAR          COLOR_DEFAULT_GRAY
#define COLOR_TAB_BAR           COLOR_DEFAULT_GRAY

#define COLOR_LIGHT_GRAY [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]

#define CLEAR_COLOR [UIColor clearColor]

#define WHITE_COLOR [UIColor whiteColor]


#endif
