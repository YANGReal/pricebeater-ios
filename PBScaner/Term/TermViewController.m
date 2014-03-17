//
//  TermViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-3-3.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "TermViewController.h"

@interface TermViewController ()
{
    IBOutlet UIScrollView *_scrollView;
}

@end

@implementation TermViewController

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
    if (!ISIP5)
    {
        _scrollView.contentSize = CGSizeMake(320, 500);
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
