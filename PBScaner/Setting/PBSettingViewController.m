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
@interface PBSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,LocationViewControllerDelegate>
{
    UILabel *locationLabel;
}
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
    //[self customRightBarButtonItem];
}

- (void)customRightBarButtonItem
{
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = RECT(0, 0, 60, 30);
    doneBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [doneBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
}

- (void)done:(id)sender
{
    if (locationLabel.text.length !=0 )
    {
        [AppUtil storeObject:locationLabel.text ForKey:@"location"];
        [self showMBLoadingWithMessage:@"Saved!"];
        [self performSelector:@selector(hideMBLoading) withObject:nil afterDelay:1.0];

    }
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
    cell.textLabel.textColor = COLOR_RGB(91, 91, 91);
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
    
    if (indexPath.section == 0)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:RECT(20, 10, 14, 20)];
        imgView.image = [UIImage imageFromMainBundleFile:@"icon_location.png"];
        [cell.contentView addSubview:imgView];
        cell.textLabel.text = @"";
        
        UILabel *label = [[UILabel alloc] initWithFrame:RECT(imgView.x+imgView.width+10, 0, 100, 40)];
        //label.backgroundColor = COLOR_DEFAULT_YELLOW;
        label.font = [UIFont fontWithName:@"Avenir Next" size:16];
        label.text = @"My Location";
        label.textColor = COLOR_RGB(91, 91, 91);
        [cell.contentView addSubview:label];
        
        locationLabel = [[UILabel alloc] initWithFrame:RECT(label.x+label.width+50, 3, 100, 40)];
        //locationLabel.backgroundColor = COLOR_DEFAULT_YELLOW;
         locationLabel.textColor = COLOR_RGB(91, 91, 91);
        locationLabel.textAlignment = NSTextAlignmentRight;
        locationLabel.font = label.font;
        [cell.contentView addSubview:locationLabel];
        NSString *location = [AppUtil getObjectForKey:@"location"];
        if (location.length == 0)
        {
           locationLabel.text = @"";
            
        }
        else
        {
            locationLabel.text = location;
        }
    }

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if ([AppUtil isiPhone])
        {
            return 5+indexPath.row*4;
        }
        return 1;    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == 0)
   {
       NSString *nibName = [AppUtil getNibNameFromUIViewController:@"LocationViewController"];
       LocationViewController *locationVC = [[LocationViewController alloc] initWithNibName:nibName bundle:nil];
       locationVC.delegate = self;
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
       NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/price-beater-canada/id859758535?ls=1&mt=8"];
       [[UIApplication sharedApplication] openURL:url];
   }
   if (indexPath.section == 2&&indexPath.row == 1)
   {
        
   }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 26;
    }
    return 20;
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

#pragma mark - LocationViewControllerDelegate method

- (void)backFromLocationViewControllerWithLocation:(NSString *)location
{
    locationLabel.text = location;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
