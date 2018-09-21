#import "BarcodeDetectorManager.h"

@interface BarcodeDetectorManager ()
@property(nonatomic, strong) GMVDetector *barcodeDetector;
@property(nonatomic, assign) float scaleX;
@property(nonatomic, assign) float scaleY;
@end

@implementation BarcodeDetectorManager

- (instancetype)init
{
  if (self = [super init]) {
    NSDictionary *options = @{GMVDetectorBarcodeFormats : @(GMVDetectorBarcodeFormatCode128)};
    self.barcodeDetector = [GMVDetector detectorOfType:GMVDetectorTypeBarcode options:options];
  }
  return self;
}

- (NSArray *)findBarcodesInFrame:(UIImage *)image scaleX:(float)scaleX scaleY:(float) scaleY
{
  self.scaleX = scaleX;
  self.scaleY = scaleY;
  NSArray<GMVBarcodeFeature *> *features = [self.barcodeDetector featuresInImage:image options:nil];
  NSArray *barcodes = [self processFeature:features];
  return barcodes;
}

-(NSArray *)processFeature:(NSArray *)features
{
  NSMutableArray *barcodes = [[NSMutableArray alloc] init];
    for (GMVBarcodeFeature *barcode in features) {
      NSDictionary *barcodeDict = 
        @{@"type": barcode.type, @"data" : barcode.rawValue, @"bounds" : [self processBounds:barcode.bounds]};
      [barcodes addObject:barcodeDict];
  }
  return barcodes;
}

-(NSDictionary *)processBounds:(CGRect)bounds 
{
  float width = bounds.size.width * _scaleX;
  float height = bounds.size.height * _scaleY;
  float originX = bounds.origin.x * _scaleX;
  float originY = bounds.origin.y * _scaleY;
  NSDictionary *boundsDict =
  @{
    @"size" : @{
      @"width" : @(width), 
      @"height" : @(height)
    }, 
    @"origin" : @{
      @"x" : @(originX),
      @"y" : @(originY)
    }
  };
  return boundsDict;
}

@end
