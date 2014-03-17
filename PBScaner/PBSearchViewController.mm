//
//  PBSearchViewController.m
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBSearchViewController.h"
#import "PhoneMainViewController.h"
@interface PBSearchViewController ()
@property (weak,nonatomic) IBOutlet UITextField *searchBar;
- (IBAction)searchButtonCLicked:(id)sender;
@end

@implementation PBSearchViewController

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
	// Do any additional setup after loading the view.
    [self setupUI];
}
#pragma mark - 设置UI

- (void)setupUI
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, 140, 40)];
    titleImageView.image = [UIImage imageNamed:@"logo.png"];
    self.navigationItem.titleView = titleImageView;
    UIView *line = [[UIView alloc] initWithFrame:RECT(0, 0, [AppUtil getDeviceWidth], 1)];
    line.backgroundColor = COLOR_LIGHT_GRAY;
    [self.navigationController.navigationBar addSubview:line];
    
}


/*点击搜索栏*/
- (IBAction)searchButtonCLicked:(id)sender
{
    if (self.searchBar.editing)
    {
         [self.searchBar resignFirstResponder];
    }
    
}

/*点击界面收回键盘*/
- (void)handleTap
{
    if (self.searchBar.editing)
    {
        [self.searchBar resignFirstResponder];
    }

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action


@end
