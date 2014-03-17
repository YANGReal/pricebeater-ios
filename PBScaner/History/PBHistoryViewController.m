//
//  PBHistoryViewController.m
//  PBScanner
//
//  Created by 0day on 14-2-19.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBHistoryViewController.h"
#import "GoodsCell.h"
//#import "PBHistoryDataSource.h"
#import "GoodDetailViewController.h"

@interface PBHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak , nonatomic) IBOutlet  UITableView *tableView;

@property (strong , nonatomic) NSMutableArray *historyArray;
@end

@implementation PBHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:CACH_DOCUMENTS_PATH(@"history.plist")];
    if (self.historyArray == nil&&self.historyArray.count == 0)
    {
        self.historyArray = [NSMutableArray array];
    }
    [self.tableView reloadData];
    if (self.historyArray.count == 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
   
}

- (void)setupUI
{
    //self.navigationController.navigationItem.rightBarButtonItem
    self.title = @"History";
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = RECT(0, 0, 100, 30);
    [clearButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [clearButton setTitle:@"Clear All" forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [clearButton addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    
    self.tableView.height = [AppUtil getDeviceHeight];

}

- (void)clearAll
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure to clear?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    [alert show];
    return;
    [self.historyArray removeAllObjects];
    [self.tableView reloadData];
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:CACH_DOCUMENTS_PATH(@"history.plist")];
}


#pragma mark - UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0)
    {
        [self.historyArray removeAllObjects];
        [self.tableView reloadData];
        [NSKeyedArchiver archiveRootObject:self.historyArray toFile:CACH_DOCUMENTS_PATH(@"history.plist")];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - UITableView Datasource && Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
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
    
    cell.data = self.historyArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.historyArray[indexPath.row];
    return [GoodsCell cellHeightWithData:data];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.historyArray[indexPath.row];
    GoodDetailViewController *detailVC = [[GoodDetailViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"GoodDetailViewController"] bundle:nil];
    detailVC.urlString = [data stringAttribute:@"url"];
    [self presentViewController:detailVC animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.historyArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:CACH_DOCUMENTS_PATH(@"history.plist")];
    if (self.historyArray.count == 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
