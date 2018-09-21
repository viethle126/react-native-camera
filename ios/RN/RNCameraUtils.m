//
//  RNCameraUtils.m
//  RCTCamera
//
//  Created by Joao Guilherme Daros Fidelis on 19/01/18.
//

#import "RNCameraUtils.h"

@implementation RNCameraUtils

# pragma mark - Camera utilities

+ (AVCaptureDevice *)deviceWithMediaType:(AVMediaType)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

+ (AVCaptureVideoOrientation)videoOrientationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        default:
            return 0;
    }
}

+ (UIImage *)convertBufferToUIImage:(CMSampleBufferRef)sampleBuffer previewSize:(CGSize)previewSize
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    // set correct orientation
    UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (curOrientation == UIInterfaceOrientationLandscapeLeft){
        ciImage = [ciImage imageByApplyingOrientation:3];
    } else if (curOrientation == UIInterfaceOrientationLandscapeRight){
        ciImage = [ciImage imageByApplyingOrientation:1];
    } else if (curOrientation == UIInterfaceOrientationPortrait){
        ciImage = [ciImage imageByApplyingOrientation:6];
    } else if (curOrientation == UIInterfaceOrientationPortraitUpsideDown){
        ciImage = [ciImage imageByApplyingOrientation:8];
    }
    float bufferWidth = CVPixelBufferGetWidth(imageBuffer);
    float bufferHeight = CVPixelBufferGetHeight(imageBuffer);

    // Removed scaling to improve barcode detection
    NSDictionary *contextOptions = @{kCIContextUseSoftwareRenderer : @(false)};
    CIContext *temporaryContext = [CIContext contextWithOptions:contextOptions];
    CGImageRef videoImage;
    CGRect boundingRect;
    if (curOrientation == UIInterfaceOrientationLandscapeLeft || curOrientation == UIInterfaceOrientationLandscapeRight) {
        boundingRect = CGRectMake(0, 0, bufferWidth, bufferHeight);
    } else {
        boundingRect = CGRectMake(0, 0, bufferHeight, bufferWidth);
    }
    videoImage = [temporaryContext createCGImage:ciImage fromRect:boundingRect];
    CGRect croppedSize = AVMakeRectWithAspectRatioInsideRect(previewSize, boundingRect);
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(videoImage, croppedSize);
    UIImage *image = [[UIImage alloc] initWithCGImage:croppedCGImage];
    CGImageRelease(videoImage);
    CGImageRelease(croppedCGImage);
    return image;
}

@end
