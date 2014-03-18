//
//  PBScanViewController.m
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "ScanDetailViewController.h"
#import "PBScanViewController.h"
#import "PBScannerView.h"
#import "GoodsListViewController.h"
@interface PBScanViewController ()<PBScannerViewDelegate,ScanDetailViewControllerDelegate,GoodsListViewControllerDelagate>

@property (strong , nonatomic) PBScannerView *readerView;
@property (weak , nonatomic) IBOutlet UILabel *label;
@property (weak , nonatomic) IBOutlet UIView *bgView;
@property (weak , nonatomic) IBOutlet UIView *line;
@property (weak , nonatomic) IBOutlet UIView *promptView;

- (IBAction)priceTagBtnClicked:(id)sender;


@end

@implementation PBScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Scan";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
	// Do any additional setup after loading the view.
}


- (void)setupUI
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, 140, 40)];
    titleImageView.image = [UIImage imageNamed:@"logo.png"];
    self.navigationItem.titleView = titleImageView;

    self.readerView = [[PBScannerView alloc] initWithFrame:self.view.bounds];
    self.readerView.delegate = self;
    [self.view addSubview:self.readerView];
    [self.readerView startScan];
    
    //self.label.layer.frame = self.label.bounds;
    [self.view.layer addSublayer:self.label.layer];
    self.bgView.center = self.view.center;
    [self.view.layer addSublayer:self.bgView.layer];
    [UIView animateWithDuration:1.0 animations:^{
        self.line.frame = RECT(0, self.bgView.height-20, 265, 1);
    } completion:^(BOOL finished) {
        [self animate];
    }];

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

#pragma mark - 重置扫描界面

- (void)resetScanView
{
    [self.view addSubview:_readerView];
    [self.readerView startScan];
    [self.view.layer addSublayer:self.label.layer];
    self.bgView.center = self.view.center;
    [self.view.layer addSublayer:self.bgView.layer];
    [self.promptView removeFromSuperview];
    self.line.hidden = NO;
    
}


#pragma mark -进入商品404界面

- (void)showPromptView
{
    NSString *nibName = [AppUtil getNibNameFromUIViewController:@"PBScanViewController"];
    self.promptView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    
    self.promptView.layer.frame = RECT(0, NAV_HEIGHT, [AppUtil getDeviceWidth], [AppUtil getDeviceHeight]-NAV_HEIGHT-TABBAR_HEIGHT);
    [self.view addSubview:self.promptView];
}

#pragma mark -进入商品列表界面

- (void)showGoodsListWithData:(NSArray *)data
{
    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] initWithNibName:@"GoodsListViewController" bundle:nil];
    goodsListVC.dataArray = data;
    goodsListVC.delagate = self;
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

#pragma mark - IBAction Method
/*扫描priceTag界面*/
- (IBAction)priceTagBtnClicked:(id)sender
{
    ScanDetailViewController *scanDetailVC = [[ScanDetailViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"ScanDetailViewController"] bundle:nil];
    scanDetailVC.scanType = priceTagType;
    scanDetailVC.delegate = self;
    [self.navigationController pushViewController:scanDetailVC animated:YES];
    [((PBMainViewController *)self.tabBarController) hideTabBar];
}

#pragma mark -ScanDetailViewController delegate method

- (void)backFromScanDetailViewController:(ScanDetailViewController *)vc
{
    [self resetScanView];
}


#pragma mark -GoodsListViewControllerDelagate method


- (void)backFromGoodsListViewController:(GoodsListViewController *)vc
{
    [self resetScanView];
}

#pragma mark -PBScannerViewDelegate method


- (void)pbScannerViewDidOutputResult:(NSString *)result
{
    DLog(@"result>>> = %@",result);
    self.line.hidden = YES;
    [self loadDataFromServerWithCode:result];
}


#pragma mark - 从服务器加载数据

- (void)loadDataFromServerWithCode:(NSString *)code
{
    //DLog(@"code = %@",code);
    NSDictionary *params = [NSDictionary dictionaryWithObject:code forKey:@"upc"];
    [self showMBLoadingWithMessage:@"Loding"];
    [NBNetworkEngine loadDataWithURL:kRequestURL params:params completeHander:^(id jsonObject, BOOL success) {
        if (success)
        {
            NSDictionary *dict = (NSDictionary *)jsonObject;
            NSArray * data = [dict objectForKey:@"response"];
            if (data.count!=0)
            {
                /*存在数据,进入商品列表界面*/
                [self showGoodsListWithData:data];
            }
            else
            {
                /*不存在商品信息,进入*/
                [self showPromptView];
            }
            [self hideMBLoading];
        }
        else
        {
            [self hideMBLoading];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
