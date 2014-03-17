//
//  ContactViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-3-3.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

- (IBAction)mailButtonClicked:(id)sender;

- (IBAction)phoneButtonClicked:(id)sender;

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           self.title = @"Setting";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customLeftBarButtonItem];
    // Do any additional setup after loading the view from its nib.
}

- (void)customLeftBarButtonItem
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, 30, 30)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageFromMainBundleFile:@"back.png"]];
    imgView.y = 5;
    [view addSubview:imgView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = RECT(5, 0, 60, 30);
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [backBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}


- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mailButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send mail",@"Copy link", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

- (IBAction)phoneButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call ",@"Copy ", nil];
    actionSheet.tag = 200;
    [actionSheet showInView:self.view];
}

#pragma mark -UIActionSheet delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //DLog(@"index = %ld",buttonIndex);
    if (actionSheet.tag == 100)
    {
        if (buttonIndex == 0)
        {
            [self sendMail];
        }
        if (buttonIndex == 1)
        {
            [self copyLink:@"info@pricebeater.ca"];
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            [self call];
        }
        if (buttonIndex == 1)
        {
            [self copyLink:@"+1 647-478-7733"];
        }

    }
}

#pragma mark - Operation Method

- (void)call
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://16474787733"]];
}

- (void)copyLink:(NSString *)link
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = link;
}


- (void)sendMail
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (mc)
    {
        mc.mailComposeDelegate = self;
        [mc setToRecipients:[NSArray arrayWithObjects:@"info@pricebeater.ca",
                        nil]];
        [self presentViewController:mc animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please setup you E-mail account in Settings app" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
   
}
#pragma mark- MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
