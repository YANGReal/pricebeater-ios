//
//  GoodsListViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-3-5.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsCell.h"
#import "GoodDetailViewController.h"
@interface GoodsListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak , nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) NSMutableArray *historyArray;
@end

@implementation GoodsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Scan";
        self.historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:CACH_DOCUMENTS_PATH(@"history.plist")];
        if (self.historyArray == nil&&self.historyArray.count == 0)
        {
            self.historyArray = [NSMutableArray array];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ((PBMainViewController *)self.tabBarController).showTabBar = YES;
    [self customLeftBarButtonItem];
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
    if ([self.delagate respondsToSelector:@selector(backFromGoodsListViewController:)])
    {
        [self.delagate backFromGoodsListViewController:self];
    }
    ((PBMainViewController *)self.tabBarController).showTabBar = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)storeHistoryData:(id)data
{
    
    [self.historyArray insertObject:data atIndex:0];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.historyArray toFile:CACH_DOCUMENTS_PATH(@"history.plist")];
    if (success)
    {
        DLog(@"Archiver succeed!");
    }
    else
    {
         DLog(@"Archiver failed");
    }
}

#pragma mark -UITableViewDataSource &&UITableViewDelegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    GoodsCell *cell = (GoodsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsCell" owner:self options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataArray[indexPath.row];
    return [GoodsCell cellHeightWithData:data];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *data = self.dataArray[indexPath.row];
    GoodDetailViewController *detailVC = [[GoodDetailViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"GoodDetailViewController"] bundle:nil];
    NSString *hash = [data stringAttribute:@"urlhash"];
    detailVC.urlString = PRODUCT_DETAIL_URL(hash);
    detailVC.historyURL = PRODUCT_HISTORY_URL(hash);
    detailVC.dataArray = self.dataArray;
    detailVC.currentIndex = indexPath.row;
    [self presentViewController:detailVC animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self storeHistoryData:data];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
