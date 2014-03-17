//
//  AppUtil.m
//  PBScanner
//
//  Created by YANGReal on 14-2-26.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "AppUtil.h"

@implementation AppUtil

+(BOOL)isiPhone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}


+(NSString *)getNibNameFromUIViewController:(NSString *)vc
{
    NSString *suffix = nil;
    if ([AppUtil isiPhone])
    {
        suffix = @"iPhone";
    }
    else
    {
        suffix = @"iPad";
    }
    return [NSString stringWithFormat:@"%@_%@",vc,suffix];
}



+(CGFloat)getDeviceWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}


+(CGFloat)getDeviceHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+(void)storeObject:(NSObject *)obj ForKey:(NSString *)key;
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)getObjectForKey:(NSString *)key
{
  return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+ (CGSize)getLabelSizeWithText:(NSString *)text font:(int)fontSize width:(float)width
{
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:fontSize];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    NSDictionary *attr = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return  [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}

+ (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
