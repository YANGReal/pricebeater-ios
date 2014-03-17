//
//  PBScanTagView.m
//  PBScanner
//
//  Created by YANGReal on 14-3-9.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "PBScanTagView.h"
#import "baseapi.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "math.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface PBScanTagView ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    tesseract::TessBaseAPI *tess;
    BOOL focusdone;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureSession *session;
    AVCaptureDevice *device;

}
@end

@implementation PBScanTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self startTesseract];
        [self setupSession];
    }
    return self;
}

- (void)setupSession
{
    focusdone = NO;
    session = [[AVCaptureSession alloc] init];
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    
    [device addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (input)
    {
        [session addInput:input];
    }
    else
    {
        DLog(@"Error: %@", error);
    }
    
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    session = [[AVCaptureSession alloc] init];
    [session addInput:input];
    [session addOutput:captureOutput];
    [session setSessionPreset:AVCaptureSessionPresetMedium];
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.frame = self.bounds;
    [self.layer addSublayer:previewLayer];
}

- (void)startScan
{
    [session startRunning];
}

- (void)free
{
    [device removeObserver:self forKeyPath:@"adjustingFocus" context:nil];
}

- (void)stopScan
{
    [session stopRunning];
    //[previewLayer removeFromSuperlayer];
}

- (void) startTesseract
{
	//NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
    NSString *dataPath = [CACHPATH stringByAppendingPathComponent:@"tessdata"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	if (![fileManager fileExistsAtPath:dataPath]) {
		NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
		NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
		if (tessdataPath) {
			[fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
		}
	}
	
	NSString *dataPathWithSlash = [CACHPATH stringByAppendingString:@"/"];
	setenv("TESSDATA_PREFIX", [dataPathWithSlash UTF8String], 1);
	
	// init the tesseract engine.
    tess = new tesseract::TessBaseAPI();
    int returnCode = tess->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng");
    
    DLog(@"returnCode = %d",returnCode);
	
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    DLog(@"dict = %@",keyPath );
    if([keyPath isEqualToString:@"adjustingFocus"])
    {
        BOOL adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
        focusdone = !adjustingFocus;
    }
    
    
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if( focusdone==YES )
    {
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        image=[self preprocessImage:image];
        [session stopRunning];
        NSString *text = [self ocrImage:image];
       // NSLog(@"ocr: %@",text);
        if([self.delegate respondsToSelector:@selector(pbScanTagViewDidOutputResult:)])
        {
            [self.delegate pbScanTagViewDidOutputResult:text];
        }
    }
}


- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image= [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
    
    CGImageRelease(quartzImage);
    
    return (image);
}


- (NSString *) ocrImage: (UIImage *) image
{
	uint32_t* _pixels;
	CGSize size = [image size];
	int width = size.width;
	int height = size.height;
	
	_pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	memset(_pixels, 0, width * height * sizeof(uint32_t));
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef context = CGBitmapContextCreate(_pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	tess->SetImage((const unsigned char *) _pixels, width, height, sizeof(uint32_t), width * sizeof(uint32_t));
	char* utf8Text = tess->GetUTF8Text();
    free(_pixels);
	return [NSString stringWithCString:utf8Text encoding:NSUTF8StringEncoding];
}

-(UIImage *)preprocessImage:(UIImage *)image {
	
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
	
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	int width, height;
	
	width = [image size].width;
	height = [image size].height;
    //	width = 640;
    //	height = 480;
	
	CGContextRef bitmap;
	
	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, height,width , CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	}
	
	if (image.imageOrientation == UIImageOrientationLeft)
    {
		DLog(@"image orientation left");
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -height);
		
	} else if (image.imageOrientation == UIImageOrientationRight)
    {
		DLog(@"image orientation right");
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -width, 0);
		
	} else if (image.imageOrientation == UIImageOrientationUp)
    {
		DLog(@"image orientation up");
		
	} else if (image.imageOrientation == UIImageOrientationDown)
    {
		DLog(@"image orientation down");
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, radians(-180.));
		
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
