//
//  PBPriceTrendViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-4-6.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBPriceTrendViewController.h"

@interface PBPriceTrendViewController ()<UIWebViewDelegate>
@property (weak , nonatomic) IBOutlet UIWebView *webView;

- (IBAction)back:(id)sender;

@end

@implementation PBPriceTrendViewController

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
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebView Delegate method

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showMBLoadingWithMessage:@"Loading"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideMBLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideMBLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
