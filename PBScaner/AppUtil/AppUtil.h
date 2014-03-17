//
//  AppUtil.h
//  PBScanner
//
//  Created by YANGReal on 14-2-26.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject

/*判断设备是否为iPhone,否则为iPad*/
+ (BOOL)isiPhone;

/*加载对应的xib文件*/
+ (NSString *)getNibNameFromUIViewController:(NSString *)vc;

/*获得屏幕的宽度*/
+ (CGFloat)getDeviceWidth;

/*获得设备的高度*/
+ (CGFloat)getDeviceHeight;

/*存储用户偏好设置*/

+ (void)storeObject:(NSObject *)obj ForKey:(NSString *)key;
/*获取用户偏好设置*/
+ (id)getObjectForKey:(NSString *)key;

/*计算字符串的高度*/
+ (CGSize)getLabelSizeWithText:(NSString *)text font:(int)fontSize width:(float)width;

/*弹出一个带提示信息的UIAlertView*/
+ (void)showAlertWithMessage:(NSString *)message;


@end
