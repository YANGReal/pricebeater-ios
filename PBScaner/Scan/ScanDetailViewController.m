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
#import "GoodDetailViewController.h"
@interface ScanDetailViewController ()<PBScannerViewDelegate,PBScanTagViewDelegate,GoodsListViewControllerDelagate,UITextFieldDelegate>
{
    BOOL reset;
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
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak , nonatomic) IBOutlet UIView *promptView;
@property (weak , nonatomic) IBOutlet UIView *yellowView;
- (IBAction)back:(id)sender;
- (IBAction)scanBarCode:(id)sender;
- (IBAction)scanPriceTag:(id)sender;

- (IBAction)searchProduct:(id)sender;

@end

@implementation ScanDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Scan";
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self customLeftBarButtonItem];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [(PBMainViewController *)self.tabBarController hideTabBarWithType:self.tag];
}


- (void)setupUI
{
    self.bottomView.hidden = YES;
    self.bgView.backgroundColor = CLEAR_COLOR;
    self.yellowView.backgroundColor = COLOR_DEFAULT_YELLOW;
    UIImageView *mask = [[UIImageView alloc] initWithFrame:RECT(0, 64, self.view.width, self.view.height-64)];
  //  DLog(@"self.height = %f",self.view.height);
    NSString *imgName = @"scan_mask_iPhone.png";
    if ([AppUtil isiPhone])
    {
        imgName = @"scan_mask_iPad.png";
        if (!ISIP5)
        {
            self.bgView.y-= 6;
            mask.height = 568-64;
        }
       
     
    }
    mask.image = [UIImage imageFromMainBundleFile:@"scan_mask_iPad.png"];
    
    [self.view.layer addSublayer:mask.layer];

    [self.view.layer addSublayer:self.topView.layer];
    [self.view.layer addSublayer:self.bottomView.layer];
    [self.view.layer addSublayer:self.label.layer];
   // self.bgView.center = self.view.center;
    [self.view.layer addSublayer:self.bgView.layer];
    self.promptView.layer.frame = self.promptView.bounds;
    [self.view.layer addSublayer:self.promptView.layer];
    [self.view addSubview:self.promptView];
   // self.promptView.hidden = NO;
    if (!ISIP5)
    {
        self.bgView.y += 6;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
      //  self.line.frame = RECT(9, self.bgView.height-20, 240, 1);
        self.line.y = self.bgView.height- 25;
    } completion:^(BOOL finished) {
        [self animate];
    }];
    
}
    
    
- (void)customLeftBarButtonItem
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, 60, 30)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageFromMainBundleFile:@"back.png"]];
    imgView.frame = RECT(0, 5, 11, 17);
    [view addSubview:imgView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = RECT(5, -1, 60, 30);
    // self.backBtn.backgroundColor = [UIColor yellowColor];
    backBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [backBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
   // backBtn.tag  = 100;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

}
    
    
- (void)back:(id)sender
{
    if (self.tag == 100)//push 进入的
    {
        [self.navigationController popViewControllerAnimated:YES];
        //[((PBMainViewController *)self.tabBarController) revealTabBar];
        if ([self.delegate respondsToSelector:@selector(backFromScanDetailViewController:)])
        {
            [self.delegate backFromScanDetailViewController:self];
        }
    }
    else
    {
        
        self.tabBarController.selectedIndex = 0;
        [((PBMainViewController *)self.tabBarController) highLightedFirstTabBarItem];
         [((PBMainViewController *)self.tabBarController) revealTabBarWithType:100];
        
        
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
    //if (pro)
    [self hidePromptView];
}

- (void)animate
{
    [UIView animateWithDuration:1.0 animations:^{
       // self.line.frame = RECT(2, 20, 258, 1);
        self.line.y = 10;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 animations:^{
            //self.line.frame = RECT(2, self.bgView.height-20, 258, 1);
            self.line.y = self.bgView.height -25;
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
                listVC.delagate = self;
                [self.navigationController pushViewController:listVC animated:YES];
            }
            else
            {
                if (self.scanType == barCodeType)
                {
                    [self showPromptView];
                }
                else
                {
                    [self showMBFailedWithMessage:@"no produect!"];
                }
            }
            [self hideMBLoading];
        }
        else
        {
            [self hideMBLoading];
        }
    }];
}

#pragma mark - show prompt View

- (void)showPromptView
{
    self.promptView.hidden = NO;
     [(PBMainViewController *)self.tabBarController revealTabBarWithType:100];
    //self.bottomView.hidden = YES;
}

- (void)hidePromptView
{
    self.promptView.hidden = YES;
    [(PBMainViewController *)self.tabBarController hideTabBarWithType:100];
  //  self.bottomView.hidden = NO;

}

#pragma mark - IBAction Method

- (IBAction)scanBarCode:(id)sender
{
    [self performSelectorInBackground:@selector(startScanBarCode) withObject:nil];

}
- (IBAction)scanPriceTag:(id)sender
{

  //  [self performSelectorInBackground:@selector(startScanPriceTag) withObject:nil];
}

- (IBAction)searchProduct:(id)sender
{
    [self loadDataFromServerWithText:self.searchField.text];
    [self.searchField resignFirstResponder];
}

#pragma mark - PBScanTagViewDelegate method


- (void)pbScanTagViewStartProcessImage:(UIImage *)image
{
    self.line.hidden = YES;
    [self performSelectorOnMainThread:@selector(showMBLoadingWithMessage:) withObject:@"Loading" waitUntilDone:NO];
}

- (void)pbScanTagViewDidOutputResult:(NSString *)result
{
   // DLog(@"result = %@",result);
    
    reset = YES;
    [self loadDataFromServerWithCode:result];
}


#pragma mark - View Will Disappear

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
   // [self.scanTagView removeFromSuperview];
    //[self.scanTagView free];
    self.scanTagView = nil;
    [self.readerView removeFromSuperview];
    self.readerView = nil;
    [((PBMainViewController *)self.tabBarController) revealTabBarWithType:self.tag];
}


#pragma mark -PBScannerViewDelegate

- (void)pbScannerViewDidOutputResult:(NSString *)result
{
    self.line.hidden = YES;
   // DLog(@"result = %@",result);
    reset = YES;
    [self showMBLoadingWithMessage:@"Loading"];
    [self loadDataFromServerWithCode:result];
}

#pragma mark -GoodsListViewControllerDelagate method

- (void)backFromGoodsListViewController:(GoodsListViewController *)vc
{   reset = YES;
    [self.tabBarController performSelector:@selector(hideTabBarWithType:) withObject:@100];
}

#pragma mark - View will appear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    {
        if (self.scanType == barCodeType)
        {
          
            [self hidePromptView];
            [self.readerView removeFromSuperview];
            self.readerView = nil;
            [self performSelectorInBackground:@selector(startScanBarCode) withObject:nil];
        }
        else
        {
            [self.scanTagView removeFromSuperview];
            [self.scanTagView free];
            self.scanTagView = nil;
            [self performSelectorInBackground:@selector(startScanPriceTag) withObject:nil];
        }
    }
}


#pragma mark - UITextFieldDelegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadDataFromServerWithText:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 搜索数据

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
}



#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
