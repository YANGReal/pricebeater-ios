//
//  LocationViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-3-2.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()<UIGestureRecognizerDelegate>
{
    IBOutlet UIView *cell;
    IBOutlet UITextField *textField;
    
}
@end

@implementation LocationViewController

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
    [self setupUI];
}

- (void)setupUI
{
    
    self.view.backgroundColor = COLOR_RGB(250, 250, 250);
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    cell.backgroundColor = WHITE_COLOR;
    [cell setupBorder:COLOR_RGB(226, 226, 226) cornerRadius:0];
   
    [self customLeftBarButtonItem];
    [self customRightBarButtonItem];
    [textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
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

- (void)customRightBarButtonItem
{
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = RECT(0, 0, 60, 30);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [doneBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];

    
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done:(id)sender
{
    DLog(@"23");
    [textField resignFirstResponder];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
