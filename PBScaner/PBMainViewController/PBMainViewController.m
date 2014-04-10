//
//  MainViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-2-26.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBMainViewController.h"
#import "PBSearchViewController.h"

#import "PBSettingViewController.h"
#import "PBHistoryViewController.h"
#import "ScanDetailViewController.h"
@interface PBMainViewController ()
@property (strong , nonatomic) UIView *myTabBar;
@end

@implementation PBMainViewController

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
    [self _setupViewControllers];
    // Do any additional setup after loading the view from its nib.
    [self _setupTabBar];
    
}

- (void)_setupViewControllers
{
    PBSearchViewController *searchVC = [[PBSearchViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"PBSearchViewController"] bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:searchVC];
    
    ScanDetailViewController *scanVC = [[ScanDetailViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"ScanDetailViewController"] bundle:nil];
    scanVC.tag = 200;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:scanVC];
    
    PBHistoryViewController *historyVC = [[PBHistoryViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"PBHistoryViewController"] bundle:nil];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:historyVC];
    
    PBSettingViewController *settingVC = [[PBSettingViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"PBSettingViewController"] bundle:nil];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:settingVC];
    self.viewControllers = @[nav1,nav2,nav3,nav4];
}

- (void)_setupTabBar
{
    self.tabBar.hidden = YES;
    CGFloat iconSpace = 0;
    CGFloat titleSpace = 0;
    CGFloat x1 = 0;
    CGFloat x2 = 0;
    if([AppUtil isiPhone])
    {
        iconSpace = 50;
        titleSpace = 17;
        x1 = 30;
        x2 = 10;
    }
    else
    {
        iconSpace = 100;
        titleSpace = 65;
        x1 = 181;
        x2 = 165;
    }

    CGRect rect = [[UIScreen mainScreen] bounds];
    self.myTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, [AppUtil getDeviceHeight]-49, [AppUtil getDeviceWidth], 49)];
    self.myTabBar.backgroundColor = COLOR_DEFAULT_GRAY;
    [self.view addSubview:self.myTabBar];
    
    NSArray *iconArr = @[@"icon_search.png",@"icon_scan.png",@"icon_history.png",@"icon_setting.png"];
    NSArray *titleArr = @[@"Search",@"Scan",@"History",@"Setting"];
    CGFloat btnWidth = rect.size.width/4.0;
    for (int i = 0;i<4;i++)
    {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:RECT(x1+26*i+iconSpace*i, 5, 26,26)];
        iconView.image = [UIImage imageNamed:iconArr[i]];
        [self.myTabBar addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:RECT(x2+60*i+titleSpace*i, 30, 60, 20)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:9];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:@"#B3B2B2"];
        if (i == 0)
        {
            titleLabel.textColor = WHITE_COLOR;
        }
        titleLabel.text = titleArr[i];
        titleLabel.tag = i+100;
        [self.myTabBar addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+100;
       // button.backgroundColor = COLOR_DEFAULT_YELLOW;
      
        if ([AppUtil isiPhone])
        {
             button.frame = RECT(i*btnWidth, 0, rect.size.width/4.0, 49);
        }
        else
        {
            button.frame = RECT(100*i+160+10*i, 0, 100, 49);
        }
        [button addTarget:self action:@selector(tabBarTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.myTabBar addSubview:button];
    }
    UIView *line = [[UIView alloc] initWithFrame:RECT(0, 0, [AppUtil getDeviceWidth],0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#525252"];
    [self.myTabBar addSubview:line];
}

- (void)tabBarTapped:(UIButton *)sender
{
   
    for (UIView *view in self.myTabBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            UILabel *titleLabel = (UILabel *)view;
            if (titleLabel.tag == sender.tag)
            {
                titleLabel.textColor = WHITE_COLOR;
            }
            else
            {
                titleLabel.textColor = [UIColor colorWithHexString:@"#B3B2B2"];
            }
        }
    }
    
    self.selectedIndex = sender.tag-100;
   if (self.selectedIndex == 1)
   {
      if (self.showTabBar == NO)
      {
        [self hideTabBarWithType:200];   
      }
   }
}

- (void)highLightedFirstTabBarItem
{
    for (UIView *view in self.myTabBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            UILabel *titleLabel = (UILabel *)view;
            if (titleLabel.tag == 100)//第一个标签
            {
                titleLabel.textColor = WHITE_COLOR;
            }
            else//其他标签
            {
                titleLabel.textColor = [UIColor colorWithHexString:@"#B3B2B2"];
            }
        }
    }
}
    
- (void)hideTabBarWithType:(int)type
{
    if (type == 100)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.myTabBar.x = -self.myTabBar.width;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.myTabBar.y = self.myTabBar.y+49;
        }];
    }
     // DLog(@"frame1 = %@",NSStringFromCGRect(_myTabBar.frame));
}
    
- (void)revealTabBarWithType:(int)type
{
   
    if (type == 100)
    {
        self.myTabBar.y = [AppUtil getDeviceHeight] -49;
        [UIView animateWithDuration:0.3 animations:^{
            self.myTabBar.x = 0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.myTabBar.y = [AppUtil getDeviceHeight]-49;
        }];
    }
  //  DLog(@"frame2 = %@",NSStringFromCGRect(_myTabBar.frame));
}
    
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
