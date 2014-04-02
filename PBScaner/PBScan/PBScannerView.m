//
//  PBScanner.m
//  PBScanner
//
//  Created by YANGReal on 14-3-9.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

#import "PBScannerView.h"
#import <AVFoundation/AVFoundation.h>
@interface PBScannerView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL isFinished;
}
@property (strong , nonatomic) AVCaptureSession *session;
@property (strong , nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end


@implementation PBScannerView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSession];
    }
    return self;
}


- (void)setupSession
{
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (input)
    {
       
        [self.session addInput:input];
    }
    else
    {
        NSLog(@"Error: %@", error.description);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code]];
    
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.previewLayer];
    
}

- (void)startScan
{
    [self.session startRunning];
}

- (void)stopScan
{
    [self.session stopRunning];
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate delegate method

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    NSString *code = nil;
    for (AVMetadataObject *metadata in metadataObjects)
    {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeEAN13Code])
        {
            code = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
             [self stopScan];
            if ([self.delegate respondsToSelector:@selector(pbScannerViewDidOutputResult:)])
            {
                [self.delegate pbScannerViewDidOutputResult:code];
            }
        }
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self stopScan];
}


@end
