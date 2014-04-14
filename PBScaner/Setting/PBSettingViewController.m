//
//  PBSettingViewController.m
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "PBSettingViewController.h"
#import "LocationViewController.h"
#import "AboutViewController.h"
#import "ContactViewController.h"
#import "TermViewController.h"
@interface PBSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,LocationViewControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
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
       UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share to" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter",@"Facebook", @"SMS",@"Mail",nil];
       [actionSheet showInView:self.view];
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

#pragma mark - UIActionSheetDelegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"index = %d",buttonIndex);
    if (buttonIndex == 0)
    {
        [self shareToTwitter];
    }
    if (buttonIndex == 1)
    {
        [self shareToFacebook];
    }
     if (buttonIndex == 2)
     {
         [self sendSMS];
     }
    if (buttonIndex == 3)
    {
        [self sendMail];
    }
    
}


#pragma mark - Share to Facebook

- (void)shareToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposerSheet setInitialText:@"PriceBeater"];
        NSString *url = @"https://itunes.apple.com/us/app/price-beater-canada/id859758535?ls=1&mt=8";
        [slComposerSheet addURL:[NSURL URLWithString:url]];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
    }
    else
    {
        [AppUtil showAlertWithMessage:@"Please setup your Facebook account in Settings"];
    }
}

#pragma mark - share to Twitter

- (void)shareToTwitter
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposerSheet setInitialText:@"PriceBeater"];
         NSString *url = @"https://itunes.apple.com/us/app/price-beater-canada/id859758535?ls=1&mt=8";
        [slComposerSheet addURL:[NSURL URLWithString:url]];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
    }
    else
    {
        [AppUtil showAlertWithMessage:@"Please setup your Twitter account in Settings"];
    }
    
}

#pragma mark - 发送邮件
- (void)sendMail
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (mc)
    {
        mc.mailComposeDelegate = self;
        // [mc setToRecipients:[NSArray arrayWithObjects:@"info@pricebeater.ca",
        //   nil]];
        
        [mc setMessageBody:@"PriceBeater https://itunes.apple.com/us/app/price-beater-canada/id859758535?ls=1&mt=8 " isHTML:NO];
        
        [self presentViewController:mc animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please setup you E-mail account in Setting" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}


#pragma mark -发送短信

- (void)sendSMS
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        //controller.recipients = [NSArray arrayWithObject:@"10010"];
        controller.body = @"PriceBeater https://itunes.apple.com/us/app/price-beater-canada/id859758535?ls=1&mt=8";
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"SMS"];//修改短信界面标题
    }
    else
    {
        [AppUtil showAlertWithMessage:@"Sorry,your device can not send sms!"];
    }
}

#pragma mark - MFMessageComposeViewController Delegate method

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
