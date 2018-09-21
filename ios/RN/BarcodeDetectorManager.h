#import <GoogleMobileVision/GoogleMobileVision.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BarcodeDetectorManager : NSObject

- (instancetype)init;

-(NSArray *)findBarcodesInFrame:(UIImage *)image scaleX:(float)scaleX scaleY:(float)scaleY;

@end
