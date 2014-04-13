//
//  GoodDetailViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-3-8.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "ShareView.h"
#import "PBPriceTrendViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Pinterest/Pinterest.h>
#define PINTEREST_APP_ID @"1436797"

@interface GoodDetailViewController ()<UIWebViewDelegate,ShareViewDelegate,MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (weak , nonatomic) IBOutlet UIWebView *webView;
@property (weak , nonatomic) IBOutlet UIButton *preBtn;
@property (weak , nonatomic) IBOutlet UIButton *nextBtn;
@property (weak , nonatomic) IBOutlet UIView *bottomView;
@property (weak , nonatomic) IBOutlet UIButton *shareBtn;
@property (weak , nonatomic) IBOutlet UIButton *historyBtn;
@property (strong , nonatomic) IBOutlet ShareView *shareView;
@property (weak , nonatomic) IBOutlet UIView *navBar;

@property (strong , nonatomic) NSString *content;

- (IBAction)back:(id)sender;

- (IBAction)preBtnClicked:(id)sender;
- (IBAction)nextBtnClicked:(id)sender;
- (IBAction)shareBtnClicked:(id)sender;
- (IBAction)historyBtnClicked:(id)sender;

@end

@implementation GoodDetailViewController

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
  //  self.navBar.backgroundColor = COLOR_DEFAULT_GRAY;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    self.nextBtn.enabled = NO;
   // self.bottomView.backgroundColor = COLOR_DEFAULT_GRAY;
    DLog(@"self.url = %@",_urlString);
    if (self.type == 100)
    {
        //self.bottomView.hidden = YES;
       // self.webView.height = [AppUtil getDeviceHeight] - 64;
    }
    
    if (![AppUtil isiPhone])
    {
        self.historyBtn.hidden= YES;
    }
    
    //DLog(@"self.dataArray = %@",self.dataArray);
    if (self.dataArray.count == 0)
    {
        [self loadDataFromServerWithText:self.keyword];
    }
}


- (void)loadDataFromServerWithText:(NSString *)text
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:text forKey:@"text"];
    [NBNetworkEngine loadDataWithURL:kRequestURL params:params completeHander:^(id jsonObject, BOOL success) {
        
         //DLog(@"obj =>>>>>>>>> %@",jsonObject);
        
        if (success)
        {
            NSDictionary *dict = (NSDictionary *)jsonObject;
            NSArray *list = [dict objectForKey:@"response"];
            if (list.count!=0)
            {
                
                [self findLowestPriceInProductData:list];
            }
        }
    }];
}

#pragma mark-

- (void)findLowestPriceInProductData:(NSArray *)array;
{
    NSMutableArray *priceArray = [NSMutableArray array];
    for (NSDictionary *product in array)
    {
        NSString *price = [product stringAttribute:@"price"];
        NSNumber *num = [NSNumber numberWithDouble:price.doubleValue];
        [priceArray addObject:num];
    }
    NSArray *arr = [priceArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
       return [obj1 compare:obj2];
   }];
    NSNumber *lowestPrice = arr[0];
   // DLog(@"arr = %@",arr);
    NSString *str = [lowestPrice stringValue];
    if ([str isEqualToString:@"0"])
    {
        str = @"0.0";
    }
  //  DLog(@"str = %@",str);
   // DLog(@"array = %@",array);
    NSDictionary *dict = nil;
    for (NSDictionary *product in array)
    {
        if ([[product stringAttribute:@"price"] isEqualToString:str])
        {
          //  DLog(@"product = %@",product);
            dict = [product copy];
            break;
        }
    
    }
   
    NSString *price = [dict stringAttribute:@"price"];
    self.urlString = [dict stringAttribute:@"url"];
    
    self.content = [NSString stringWithFormat:@"Check this out: %@ only %@!%@",self.keyword,price,_urlString];
   
    
}

#pragma mark - 手势识别
- (void)tapped:(id)sender
{
    
    if (![AppUtil isiPhone])
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.alpha=  0.0;
            
        } completion:^(BOOL finished) {
            
            [self.shareView removeFromSuperview];
            self.shareBtn.userInteractionEnabled = YES;
            
            [[self.view viewWithTag:1001] removeFromSuperview];
            
        }];
    }
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)preBtnClicked:(id)sender
{
    if (self.currentIndex <= 0)
    {
        self.currentIndex = 0;
    }
    
    NSDictionary *data = self.dataArray[self.currentIndex];
    NSString *hash = [data stringAttribute:@"urlhash"];
    self.urlString = PRODUCT_DETAIL_URL(hash);
    self.historyURL = PRODUCT_HISTORY_URL(hash);
    [self webViewLoadURL:self.urlString];
    self.currentIndex --;
    
    NSString *skuName = [[data stringAttribute:@"skuname"] stringByRemovingPercentEncoding];
    skuName = [self getProductName:skuName];
    NSString *price = [data stringAttribute:@"price"];
    self.content = [NSString stringWithFormat:@"Check this out: %@ only %@! %@",skuName,price,_urlString];

    
}
- (IBAction)nextBtnClicked:(id)sender
{
    if (self.currentIndex>=self.dataArray.count)
    {
        self.currentIndex = self.dataArray.count -1;
    }
    
    NSDictionary *data = self.dataArray[self.currentIndex];
    NSString *hash = [data stringAttribute:@"urlhash"];
    self.urlString = PRODUCT_DETAIL_URL(hash);
    self.historyURL = PRODUCT_HISTORY_URL(hash);
    [self webViewLoadURL:self.urlString];
    self.currentIndex ++;
    
    NSString *skuName = [[data stringAttribute:@"skuname"] stringByRemovingPercentEncoding];
    skuName = [self getProductName:skuName];
    NSString *price = [data stringAttribute:@"price"];
    self.content = [NSString stringWithFormat:@"Check this out: %@ only %@! %@",skuName,price,_urlString];
    
}

- (void)webViewLoadURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}



- (IBAction)historyBtnClicked:(id)sender
{
    //DLog(@"url = %@",_historyURL);
    PBPriceTrendViewController *priceVC = [[PBPriceTrendViewController alloc] initWithNibName:[AppUtil getNibNameFromUIViewController:@"PBPriceTrendViewController"] bundle:nil];
    priceVC.urlString = self.historyURL;
    [self presentViewController:priceVC animated:YES completion:nil];
    return;
    NSURL *url = [NSURL URLWithString:_historyURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


- (IBAction)shareBtnClicked:(id)sender
{
    [self addTapView];
    NSString *nibName = @"ShareView_iPad";
    if ([AppUtil isiPhone])
    {
        nibName = @"ShareView_iPhone";
    }
    self.shareView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:Nil] lastObject];
    self.shareView.delegate = self;
    if ([AppUtil isiPhone])
    {
        self.shareView.y = self.view.height+10;
    }
    else
    {
        self.shareView.alpha = 0.0;
        self.shareView.x = 358;
        self.shareView.y = 756;
        self.shareBtn.userInteractionEnabled = NO;
    }
   // shareView.y = self.view.height+10;
    [self.view addSubview:self.shareView];
    [UIView animateWithDuration:0.3 animations:^{
        if ([AppUtil isiPhone])
        {
            self.shareView.y = self.view.height- self.shareView.height;
        }
        else
        {
            self.shareView.alpha = 1.0;
        }
    }];
}

- (void)check
{
   if (self.currentIndex == 0)
   {
       self.preBtn.enabled = NO;
   }
    else
    {
        self.preBtn.enabled = YES;
    }
    if (self.currentIndex == self.dataArray.count-1)
    {
        self.nextBtn.enabled = NO;
    }
    else
    {
        self.nextBtn.enabled = YES;
    }
    if (self.dataArray.count == 0)
    {
        self.nextBtn.enabled = NO;
        self.preBtn.enabled = NO;
      //  self.historyBtn.enabled = NO;
    }
}


#pragma mark - UIWebDelegate method 

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showMBLoadingWithMessage:@"Loading"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self check];
    [self hideMBLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self check];
    [self hideMBLoading];
}

#pragma mark- ShareViewDelegate method

- (void)shareView:(ShareView *)shareView didSelectAtIndex:(int)index
{
    
    switch (index) {
        case 0:
        {
            [self shareToTwitter];
        }
            break;
          case 1:
        {
            [self shareToFacebook];
        }
            break;
        case 2:
        {
            [self copyLink];
        }
            break;
        case 3:
        {
            [self print];
        }
            break;
            case 4:
        {
            [self sendMail];
        }
            break;
        case 6:
        {
            [self sharToPintrest];
        }
            break;
            
        case 7:
        {
            [self sendSMS];
        }
            break;
        default:
            self.shareBtn.userInteractionEnabled = YES;
            break;
    }
}

#pragma mark - 分享到facebook

- (void)shareToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
      SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposerSheet setInitialText:self.content];
        [slComposerSheet addURL:[NSURL URLWithString:self.urlString]];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
    }
    else
    {
        [AppUtil showAlertWithMessage:@"Please setup your Facebook account in Settings"];
    }
}

#pragma mark - 分享到Twitter
- (void)shareToTwitter
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposerSheet setInitialText:self.content];
        [slComposerSheet addURL:[NSURL URLWithString:self.urlString]];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];

    }
    else
    {
        [AppUtil showAlertWithMessage:@"Please setup your Twitter account in Settings"];
    }

}

#pragma mark - 拷贝链接
- (void)copyLink
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = self.content;
    UIImage *img = [UIImage imageFromMainBundleFile:@"copied_successfully.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.alpha = 0.0;
    imgView.center = self.view.center;
    [self.view addSubview:imgView];
    [UIView animateWithDuration:0.5 animations:^{
        imgView.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 animations:^{
            imgView.alpha  = 0;
            
        } completion:^(BOOL finished) {
            
            [imgView removeFromSuperview];
        }];
    }];
}

#pragma mark - 发送邮件
- (void)sendMail
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (mc)
    {
        mc.mailComposeDelegate = self;
       // [mc setToRecipients:[NSArray arrayWithObjects:@"info@pricebeater.ca",
                          //   nil]];
        [mc setMessageBody:self.content isHTML:NO];
        
        [self presentViewController:mc animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please setup you E-mail account in Setting" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}


- (void)print
{
    UIImage *img = [self captureView:self.webView frame:self.webView.bounds];
    NSData *data = UIImagePNGRepresentation(img);
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if  (pic && [UIPrintInteractionController canPrintData: data] ) {
        
		pic.delegate = self;
		
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"webPage";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = data;
		
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
        {
            
			if (!completed && error)
            {
                [AppUtil showAlertWithMessage:@"Print failed!"];
            }
				
        };
        [pic presentAnimated:YES completionHandler:completionHandler];
		
	}

}

#pragma mark -发送短信

- (void)sendSMS
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        //controller.recipients = [NSArray arrayWithObject:@"10010"];
        controller.body = self.urlString;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"SMS"];//修改短信界面标题
    }
    else
    {
        [AppUtil showAlertWithMessage:@"Sorry,your device can not send sms!"];
    }
}

- (void)sharToPintrest
{
    Pinterest *pin = [[Pinterest alloc] initWithClientId:PINTEREST_APP_ID];
    NSDictionary *dict = self.dataArray[self.currentIndex];
    NSString *imgurl = [dict stringAttribute:@"img"];
    NSURL *imgURL = [NSURL URLWithString:imgurl];
    NSURL *sourceURL = [NSURL URLWithString:self.urlString];
    
    NSString *skuName = [[dict stringAttribute:@"skuname"] stringByRemovingPercentEncoding];
    NSArray *spans = [skuName componentsMatchedByRegex:@"<[^>]*>"];//找到<span标签>
    for (NSString *span in spans)
    {
        skuName = [skuName stringByReplacingOccurrencesOfString:span withString:@""];//将<span>去掉
    }
    [pin createPinWithImageURL:imgURL sourceURL:sourceURL description:self.content];
}

- (NSString *)getProductName:(NSString *)skuName
{
    NSArray *spans = [skuName componentsMatchedByRegex:@"<[^>]*>"];//找到<span标签>
    for (NSString *span in spans)
    {
        skuName = [skuName stringByReplacingOccurrencesOfString:span withString:@""];//将<span>去掉
    }
    return skuName;
}


#pragma mark - MFMessageComposeViewController Delegate method

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 截图

- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, frame);
    UIImage *image = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return image;
}


#pragma mark - 添加一个透明层

- (void)addTapView
{
    if (![AppUtil isiPhone])
    {
        UIView *tapView = [[UIView alloc] initWithFrame:self.view.bounds];
        //tapView.backgroundColor = [UIColor colorWithHexString:@"#ff0000" alpha:0.5];
        [self.view addSubview:tapView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [tapView addGestureRecognizer:tap];
        tapView.tag = 1001;
    }
}




#pragma mark - memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
