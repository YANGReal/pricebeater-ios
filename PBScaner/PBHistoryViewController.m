//
//  PBHistoryViewController.m
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBHistoryViewController.h"

#import "PBHistoryDataSource.h"

@interface PBHistoryViewController ()



@end

@implementation PBHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"History";
       // self.navigationItem.rightBarButtonItem.title = @"Clear All";
        /*
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll)];
         */
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = RECT(0, 0, 30, 30);
        [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
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
   // self.title = @"History";
}

- (void)clearAll
{
    DLog(@"123")
}

- (void)didReceiveMemoryWarning
{
    
}

@end
