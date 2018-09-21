#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>
#import <AVFoundation/AVFoundation.h>

@class RNCameraManager;

static const int RNFlashModeTorch = 3;

typedef NS_ENUM(NSInteger, RNCameraType) {
    RNCameraTypeFront = AVCaptureDevicePositionFront,
    RNCameraTypeBack = AVCaptureDevicePositionBack
};

typedef NS_ENUM(NSInteger, RNCameraFlashMode) {
    RNCameraFlashModeOff = AVCaptureFlashModeOff,
    RNCameraFlashModeOn = AVCaptureFlashModeOn,
    RNCameraFlashModeTorch = RNFlashModeTorch,
    RNCameraFlashModeAuto = AVCaptureFlashModeAuto
};

typedef NS_ENUM(NSInteger, RNCameraOrientation) {
    RNCameraOrientationAuto = 0,
    RNCameraOrientationLandscapeLeft = AVCaptureVideoOrientationLandscapeLeft,
    RNCameraOrientationLandscapeRight = AVCaptureVideoOrientationLandscapeRight,
    RNCameraOrientationPortrait = AVCaptureVideoOrientationPortrait,
    RNCameraOrientationPortraitUpsideDown = AVCaptureVideoOrientationPortraitUpsideDown
};

typedef NS_ENUM(NSInteger, RNCameraAutoFocus) {
    RNCameraAutoFocusOff = AVCaptureFocusModeLocked,
    RNCameraAutoFocusOn = AVCaptureFocusModeContinuousAutoFocus,
};

@interface RNCameraManager : RCTViewManager <RCTBridgeModule>

@end
