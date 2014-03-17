//
//  GoodDetailViewController.m
//  PBScanner
//
//  Created by YANGReal on 14-3-8.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "ShareView.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
@interface GoodDetailViewController ()<UIWebViewDelegate,ShareViewDelegate,MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate>
@property (weak , nonatomic) IBOutlet UIWebView *webView;
@property (weak , nonatomic) IBOutlet UIButton *preBtn;
@property (weak , nonatomic) IBOutlet UIButton *nextBtn;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    self.nextBtn.enabled = NO;
    
}




- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)preBtnClicked:(id)sender
{
    [self.webView goBack];
}
- (IBAction)nextBtnClicked:(id)sender
{
    [self.webView goForward];
}

- (IBAction)historyBtnClicked:(id)sender
{
    //DLog(@"url = %@",_historyURL);
    NSURL *url = [NSURL URLWithString:_historyURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


- (IBAction)shareBtnClicked:(id)sender
{
    
    ShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareView_iPhone" owner:self options:Nil] lastObject];
    shareView.delegate = self;
    if ([AppUtil isiPhone])
    {
         shareView.y = self.view.height+10;
    }
    else
    {   shareView.x = self.view.width/2.0-shareView.width/2.0;
        shareView.y = self.view.height+10;
    }
   // shareView.y = self.view.height+10;
    [self.view addSubview:shareView];
    [UIView animateWithDuration:0.3 animations:^{
        if ([AppUtil isiPhone])
        {
             shareView.y = self.view.height-shareView.height;
        }
        else
        {
            shareView.center = self.view.center;
        }
    }];
}

- (void)check
{
    if ([self.webView canGoBack])
    {
        self.preBtn.enabled = YES;
    }
    else
    {
        self.preBtn.enabled = NO;
    }
    if([self.webView canGoForward])
    {
        self.nextBtn.enabled = YES;
    }
    else
    {
        self.nextBtn = NO;
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
        default:
            break;
    }
}

#pragma mark - 分享到facebook

- (void)shareToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
      SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposerSheet setInitialText:self.urlString];
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
        [slComposerSheet setInitialText:self.urlString];
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
    pb.string = self.urlString;
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
        [mc setMessageBody:self.urlString isHTML:NO];
        
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


#pragma mark - memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
