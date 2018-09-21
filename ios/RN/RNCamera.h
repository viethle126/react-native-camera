#import <AVFoundation/AVFoundation.h>
#import <React/RCTBridge.h>
#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>

#import "BarcodeDetectorManager.h"

@class RNCamera;

@interface RNCamera : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, strong) dispatch_queue_t sessionQueue;
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDeviceInput *videoCaptureDeviceInput;
@property(nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, strong) id runtimeErrorHandlingObserver;

@property(nonatomic, assign) NSInteger presetCamera;
@property(assign, nonatomic) NSInteger flashMode;
@property(assign, nonatomic) CGFloat zoom;
@property(assign, nonatomic) NSInteger autoFocus;
@property(assign, nonatomic) float focusDepth;
@property(nonatomic, assign) BOOL canReadGoogleBarcodes;

- (id)initWithBridge:(RCTBridge *)bridge;
- (void)updateType;
- (void)updateFlashMode;
- (void)updateFocusMode;
- (void)updateFocusDepth;
- (void)updateZoom;
- (void)resumePreview;
- (void)pausePreview;
- (void)setupOrDisableBarcodeDetector;
- (void)onReady:(NSDictionary *)event;
- (void)onMountingError:(NSDictionary *)event;
- (void)onGoogleVisionBarcodesDetected:(NSDictionary *)event;

@end
