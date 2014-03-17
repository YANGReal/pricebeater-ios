//
//  PBSearchViewController.m
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBSearchViewController.h"
#import "PhoneMainViewController.h"
#import "GoodsListViewController.h"
#import "ScanDetailViewController.h"

@interface PBSearchViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak,nonatomic) IBOutlet UITextField *searchBar;
- (IBAction)searchButtonCLicked:(id)sender;
- (IBAction)scan:(id)sender;
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
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tap];
    
}


/*点击搜索栏*/
- (IBAction)searchButtonCLicked:(id)sender
{
   
    [self.searchBar resignFirstResponder];
    [self loadDataFromServerWithText:self.searchBar.text];
}

- (void)loadDataFromServerWithText:(NSString *)text
{
    if (text.length == 0)
    {
        return;
    }
    [self showMBLoadingWithMessage:@"Loading"];
    //DLog(@"url = %@",SEARCH_API(text));
    NSDictionary *params = [NSDictionary dictionaryWithObject:text forKey:@"text"];
    [NBNetworkEngine loadDataWithURL:kRequestURL params:params completeHander:^(id jsonObject, BOOL success) {
        
       // DLog(@"obj =>>>>>>>>> %@",jsonObject);
        
        if (success)
        {
            NSDictionary *dict = (NSDictionary *)jsonObject;
            NSArray *list = [dict objectForKey:@"response"];
            if (list.count!=0)
            {
                GoodsListViewController *goodsVC = [[GoodsListViewController alloc] initWithNibName:@"GoodsListViewController" bundle:nil];
                goodsVC.dataArray = list;
                goodsVC.keyword = text;
                [self hideMBLoading];
                [self.navigationController pushViewController:goodsVC animated:YES];
                
            }
            else
            {
                [self showMBFailedWithMessage:@"Ops!No Product Matched!"];
                [self hideMBLoading];
            }
        }
        else
        {
            [self showMBFailedWithMessage:@"Ops!No Product Matched!"];
            [self hideMBLoading];
        }
    }];
}

- (IBAction)scan:(id)sender
{
    ScanDetailViewController *detailVC = [[ScanDetailViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"ScanDetailViewController"] bundle:nil];
    [self.navigationController pushViewController:detailVC animated:YES];
    [((PBMainViewController *)self.tabBarController) hideTabBar];
    //[self presentViewController:detailVC animated:YES completion:nil];
    return;
    PhoneMainViewController *phoneVC = [[PhoneMainViewController alloc] initWithNibName:@"PhoneMainViewController" bundle:nil];
    [self presentViewController:phoneVC animated:YES completion:nil];
}


/*点击界面收回键盘*/
- (void)handleTap
{
    if (self.searchBar.editing)
    {
        [self.searchBar resignFirstResponder];
    }
}




#pragma mark -UIGestureRecognizerDelegate method

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count <= 1)//
    {
        return NO;
    }
    return YES;

}

#pragma mark -UITextFieldDelegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadDataFromServerWithText:textField.text];
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action


@end
