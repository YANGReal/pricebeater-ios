//
//  ScanDetailViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-3-9.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "ScanDetailViewController.h"
#import "PBScannerView.h"
#import "PBScanTagView.h"
#import "GoodsListViewController.h"
#import "AppDelegate.h"
@interface ScanDetailViewController ()<PBScannerViewDelegate,PBScanTagViewDelegate>
{

}
@property (strong , nonatomic) PBScannerView *readerView;
@property (strong , nonatomic) PBScanTagView *scanTagView;
@property (weak , nonatomic) IBOutlet UIView *bgView;
@property (weak , nonatomic) IBOutlet UIView *line;
@property (weak , nonatomic) IBOutlet UILabel *label;
@property (weak , nonatomic) IBOutlet UIView *topView;
@property (weak , nonatomic) IBOutlet UIView *bottomView;
@property (weak , nonatomic) IBOutlet UIButton *barCodeBtn;
@property (weak , nonatomic) IBOutlet UIButton *tagBtn;
@property (weak, nonatomic) IBOutlet UILabel *barCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTagLabel;
- (IBAction)back:(id)sender;
- (IBAction)scanBarCode:(id)sender;
- (IBAction)scanPriceTag:(id)sender;

@end

@implementation ScanDetailViewController

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
    [self customLeftBarButtonItem];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}


- (void)setupUI
{
    if (self.scanType == barCodeType)
    {
        
        [self performSelectorInBackground:@selector(startScanBarCode) withObject:nil];
    }
    else
    {
        [self performSelectorInBackground:@selector(startScanPriceTag) withObject:nil];
    }
    
    [self.view.layer addSublayer:self.topView.layer];
    [self.view.layer addSublayer:self.bottomView.layer];
    [self.view.layer addSublayer:self.label.layer];
    self.bgView.center = self.view.center;
    [self.view.layer addSublayer:self.bgView.layer];
    [UIView animateWithDuration:1.0 animations:^{
        self.line.frame = RECT(0, self.bgView.height-20, 265, 1);
    } completion:^(BOOL finished) {
        [self animate];
    }];
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
    [self.scanTagView free];
    [self.scanTagView removeFromSuperview];
    [self.readerView removeFromSuperview];
    [((PBMainViewController *)self.tabBarController) revealTabBar];
    if ([self.delegate respondsToSelector:@selector(backFromScanDetailViewController:)])
    {
        [self.delegate backFromScanDetailViewController:self];
    }
}


- (void)startScanBarCode
{
    self.scanType = barCodeType;
    [self.scanTagView stopScan];
    [self.scanTagView free];
    [self.scanTagView removeFromSuperview];
    self.scanTagView = nil;
    self.barCodeBtn.userInteractionEnabled = NO;
    self.tagBtn.userInteractionEnabled = YES;
    
    self.readerView = [[PBScannerView alloc] initWithFrame:self.view.bounds];
    self.readerView.delegate = self;
    [self.view insertSubview:self.readerView atIndex:0];
    [self.readerView startScan];
    self.line.hidden = NO;
    self.barCodeLabel.textColor = WHITE_COLOR;
    self.priceTagLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];

}

- (void)startScanPriceTag
{
    self.scanType = priceTagType;
    [self.readerView stopScan];
    [self.readerView removeFromSuperview];
    self.readerView = nil;
    
    self.barCodeBtn.userInteractionEnabled = YES;
    self.tagBtn.userInteractionEnabled = NO;
    self.line.hidden = NO;
    
    self.scanTagView = [[PBScanTagView alloc] initWithFrame:self.view.bounds];
    self.scanTagView.delegate = self;
    [self.view insertSubview:self.scanTagView atIndex:0];
    [self.scanTagView startScan];
    self.barCodeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];;
    self.priceTagLabel.textColor = WHITE_COLOR;

}

- (void)animate
{
    [UIView animateWithDuration:1.0 animations:^{
        self.line.frame = RECT(0, 20, 265, 1);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 animations:^{
            self.line.frame = RECT(0, self.bgView.height-20, 265, 1);
        } completion:^(BOOL finished) {
            [self animate];
            
        }];
    }];
}

- (void)loadDataFromServerWithCode:(NSString *)code
{
    DLog(@"code = %@",code);
    NSString *key = nil;
    if (self.scanType == barCodeType)
    {
        key = @"upc";
    }
    else
    {
        key = @"text";
    }
    NSDictionary *params = [NSDictionary dictionaryWithObject:code forKey:key];
   
    [NBNetworkEngine loadDataWithURL:kRequestURL params:params completeHander:^(id jsonObject, BOOL success) {
        if (success)
        {
            NSDictionary *dict = (NSDictionary *)jsonObject;
            NSArray * data = [dict objectForKey:@"response"];
            DLog(@"obj = %@",data);
            if (data.count!=0)
            {

                GoodsListViewController *listVC = [[GoodsListViewController alloc] initWithNibName:@"GoodsListViewController" bundle:nil];
                listVC.dataArray = data;
                [self.navigationController pushViewController:listVC animated:YES];
            }
            else
            {
                [self showMBFailedWithMessage:@"no produect!"];
            }
            [self hideMBLoading];
        }
        else
        {
            [self hideMBLoading];
        }
    }];
}



#pragma mark - IBAction Method

- (IBAction)scanBarCode:(id)sender
{
    [self performSelectorInBackground:@selector(startScanBarCode) withObject:nil];

}
- (IBAction)scanPriceTag:(id)sender
{

    [self performSelectorInBackground:@selector(startScanPriceTag) withObject:nil];
}


#pragma mark - PBScanTagViewDelegate method


- (void)pbScanTagViewStartProcessImage:(UIImage *)image
{
    self.line.hidden = YES;
    [self performSelectorOnMainThread:@selector(showMBLoadingWithMessage:) withObject:@"Loading" waitUntilDone:NO];
}

- (void)pbScanTagViewDidOutputResult:(NSString *)result
{
    DLog(@"result = %@",result);
   
    
    [self loadDataFromServerWithCode:result];
}




#pragma mark -PBScannerViewDelegate

- (void)pbScannerViewDidOutputResult:(NSString *)result
{
    self.line.hidden = YES;
    DLog(@"result = %@",result);
    [self showMBLoadingWithMessage:@"Loading"];
    [self loadDataFromServerWithCode:result];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
