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
#import "GoodDetailViewController.h"
@interface PBSearchViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak , nonatomic) IBOutlet UITextField *searchBar;
@property (weak , nonatomic) IBOutlet UIButton *scanButton;
@property (weak , nonatomic) IBOutlet UILabel *barLabel;
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
    
    
    if (ISIP5)
    {
        self.scanButton.y = 340;
        self.barLabel.y = self.scanButton.y+self.scanButton.height+14;
    }
    
}


#pragma mark - IBAction Method
/*点击搜索栏*/
- (IBAction)searchButtonCLicked:(id)sender
{
   
    [self.searchBar resignFirstResponder];
    [self loadDataFromServerWithText:self.searchBar.text];
}

#pragma mark - 进入商品列表界面

- (void)showGoodsListWithData:(NSArray *)data andKeyword:(NSString *)keyword
{
    GoodsListViewController *goodsVC = [[GoodsListViewController alloc] initWithNibName:@"GoodsListViewController" bundle:nil];
    goodsVC.dataArray = data;
    goodsVC.keyword = keyword;
    [self hideMBLoading];
    [self.navigationController pushViewController:goodsVC animated:YES];
}


#pragma mark - 从服务器加载数据

- (void)loadDataFromServerWithText:(NSString *)text
{
    if (text.length == 0)
    {
        return;
    }
    NSString *url = [SEARCH_URL(text) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    GoodDetailViewController *detailVC = [[GoodDetailViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"GoodDetailViewController"] bundle:nil];
    detailVC.urlString = url;
    detailVC.type = 100;
    [self presentViewController:detailVC animated:YES completion:nil];
    return;
    [self showMBLoadingWithMessage:@"Loading"];
   
    NSDictionary *params = [NSDictionary dictionaryWithObject:text forKey:@"text"];
    [NBNetworkEngine loadDataWithURL:kRequestURL params:params completeHander:^(id jsonObject, BOOL success) {
        
       // DLog(@"obj =>>>>>>>>> %@",jsonObject);
        
        if (success)
        {
            NSDictionary *dict = (NSDictionary *)jsonObject;
            NSArray *list = [dict objectForKey:@"response"];
            if (list.count!=0)
            {
                [self showGoodsListWithData:list andKeyword:text];
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
    detailVC.tag = 100;
    [self.navigationController pushViewController:detailVC animated:YES];
    [((PBMainViewController *)self.tabBarController) hideTabBarWithType:100];
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
