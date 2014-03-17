//
//  MainViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-2-26.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBMainViewController.h"
#import "PBSearchViewController.h"
#import "PBScanViewController.h"
#import "PBSettingViewController.h"
#import "PBHistoryViewController.h"

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
    
    PBScanViewController *scanVC = [[PBScanViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"PBScanViewController"] bundle:nil];
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
    if([AppUtil isiPhone])
    {
        iconSpace = 50;
      
        titleSpace = 20;
    }
    else
    {
        iconSpace = 200;
        titleSpace = 170;
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
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:RECT(25+30*i+iconSpace*i, 5, 30,30)];
        iconView.image = [UIImage imageNamed:iconArr[i]];
        [self.myTabBar addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:RECT(10+60*i+titleSpace*i, 30, 60, 20)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        if (i == 0)
        {
            titleLabel.textColor = WHITE_COLOR;
        }
        titleLabel.text = titleArr[i];
        titleLabel.tag = i+100;
        [self.myTabBar addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+100;
        button.frame = RECT(i*btnWidth, 0, rect.size.width/4.0, 49);
        [button addTarget:self action:@selector(tabBarTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.myTabBar addSubview:button];
    }
    UIView *line = [[UIView alloc] initWithFrame:RECT(0, 0, [AppUtil getDeviceWidth], 1)];
    line.backgroundColor = COLOR_LIGHT_GRAY;
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
                titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
            }
        }
    }
    self.selectedIndex = sender.tag-100;
   
}

    
    
- (void)hideTabBar
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.myTabBar.x = -self.myTabBar.width;
    }];
}
    
- (void)revealTabBar
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.myTabBar.x = 0;
    }];

}
    
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
