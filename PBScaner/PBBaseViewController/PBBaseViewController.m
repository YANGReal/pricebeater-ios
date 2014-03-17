//
//  YRBaseViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-2-26.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBBaseViewController.h"
#import "AppDelegate.h"
@interface PBBaseViewController ()

@end

@implementation PBBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if ([AppUtil isiPhone])
    {
        self.view.frame = IP5ORIP4FRAME;
    }
	// Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_NAVIGATION_BAR;
}

-(void)showMBLoadingWithMessage:(NSString *)message
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    UIWindow *window = app.window;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    hud.alpha = 0.75;
    hud.labelText = message;
    hud.tag = 1234;
    hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [window addSubview:hud];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    [hud show:YES];
}

- (void)hideMBLoading
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    UIWindow *window = app.window;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:1234];
    [hud removeFromSuperview];
    hud = nil;
}

-(void)showMBFailedWithMessage:(NSString *)message
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    UIWindow *window = app.window;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hud];
    hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
