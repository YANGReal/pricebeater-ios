//
//  PhoneMainViewController.h
//  PBScaner
//
//  Created by Huo Ju on 2/7/2014.
//  Copyright (c) 2014 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseapi.h"
#include <AVFoundation/AVFoundation.h>
#include <ImageIO/ImageIO.h>


@interface PhoneMainViewController : UIViewController <UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    UIImagePickerController *imagePickerController;
    tesseract::TessBaseAPI *tess;
    int scanner_type;
    BOOL focusdone;
    BOOL pause;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureSession *session;
}

@property (nonatomic, retain) IBOutlet UIImageView *iv;
@property (nonatomic, retain) IBOutlet UILabel *label;


- (IBAction) takePhoto:(id) sender;
- (IBAction) barcodescan:(id) sender;
- (IBAction) pause:(id) sender;

- (void) startTesseract;
- (NSString *) applicationDocumentsDirectory;
- (NSString *) ocrImage: (UIImage *) uiImage;
- (UIImage *)preprocessImage:(UIImage *)image;

@end
