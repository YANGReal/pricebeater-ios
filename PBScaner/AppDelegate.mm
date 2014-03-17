//
//  AppDelegate.m
//  PBScaner
//
//  Created by Huo Ju on 2/7/2014.
//  Copyright (c) 2014 Huo Ju. All rights reserved.
//

#import "AppDelegate.h"
#import "PhoneMainViewController.h"
#import "PBMainViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: COLOR_NAVIGATION_TITLE
                                                           }];
    [[UINavigationBar appearance] setBarTintColor:COLOR_NAVIGATION_BAR];
    //[[UIToolbar appearance] setBarTintColor:COLOR_TOOL_BAR];
    //[[UITabBar appearance] setBarTintColor:COLOR_TAB_BAR];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: WHITE_COLOR} forState:(UIControlStateNormal)];
  
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    PBMainViewController *vc = [[PBMainViewController alloc] init];
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //yangrui
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
