//
//  PBSettingViewController.m
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBSettingViewController.h"
#import "LocationViewController.h"
#import "AboutViewController.h"
#import "ContactViewController.h"
#import "TermViewController.h"
@interface PBSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) NSDictionary *configDict;
@end

@implementation PBSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SettingConfig" ofType:@"plist"];
        self.configDict = [NSDictionary dictionaryWithContentsOfFile:path];
        //DLog(@"dict = %@",self.configDict.allValues);
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Setting";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}


#pragma mark - UITableView Datasource && Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.configDict.allKeys.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
   NSArray *keys = [self.configDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
       return [obj1 compare:obj2];
   }];
    NSArray *arr = [self.configDict objectForKey:keys[section]];
    return arr.count;
   
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSArray *keys = [self.configDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2];
    }];
    NSArray *arr = [self.configDict objectForKey:keys[indexPath.section]];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
    cell.textLabel.text = arr[indexPath.row];
    if (indexPath.section == 0)
    {
        cell.imageView.image = [UIImage imageFromMainBundleFile:@"icon_location.png"];
    }
    
    if (indexPath.section <= 1&&indexPath.row<4)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1&&indexPath.row == 4)
    {
        CGFloat x = 720;
        if ([AppUtil isiPhone])
        {
            x = 280;
        }
        UILabel *visionLabel = [[UILabel alloc] initWithFrame:RECT(x, 0, 50, 44)];
        visionLabel.textColor = COLOR_RGB(59, 149, 249);
        visionLabel.text = @"1.0";
        visionLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
        [cell.contentView addSubview:visionLabel];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if ([AppUtil isiPhone])
        {
            return 5-indexPath.row;
        }
        return 1;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == 0)
   {
       NSString *nibName = [AppUtil getNibNameFromUIViewController:@"LocationViewController"];
       LocationViewController *locationVC = [[LocationViewController alloc] initWithNibName:nibName bundle:nil];
       [self.navigationController pushViewController:locationVC animated:YES];
   }
   if (indexPath.section == 1&&indexPath.row ==0)
   {
       AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"AboutViewController"] bundle:nil];
       [self.navigationController pushViewController:aboutVC animated:YES];
   }
   if (indexPath.section == 1&&indexPath.row == 1)
   {
        NSURL *url = [NSURL URLWithString:@"http://www.pricebeater.ca"];
        [[UIApplication sharedApplication] openURL:url];
   }
   if (indexPath.section == 1&&indexPath.row == 2)
   {
       ContactViewController *contactVC = [[ContactViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"ContactViewController"] bundle:nil];
       [self.navigationController pushViewController:contactVC animated:YES];
   }
   if (indexPath.section == 1&&indexPath.row==3)
   {
       TermViewController *termVC = [[TermViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"TermViewController"] bundle:nil];
       [self.navigationController pushViewController:termVC animated:YES];
   }
   if (indexPath.section == 2&&indexPath.row == 0)
   {
       NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/ibooks/id364709193?mt=8"];
       [[UIApplication sharedApplication] openURL:url];
   }
   if (indexPath.section == 2&&indexPath.row == 1)
   {
        
   }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIGesture delegate method
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
