
#import <Foundation/Foundation.h>
#import "MAGCommonDefines.h"

@interface MAGTapDetector : NSObject

@property (copy, nonatomic) MAGPointBlock willTappedBlock;
@property (copy, nonatomic) MAGPointBlock didTappedBlock;
@property (readonly, strong, nonatomic) UITapGestureRecognizer *recognizer;

- (void)attachToTargetView:(UIView *)targetView;

@end
