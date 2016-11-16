
#import "MAGLongTouchDetector.h"

typedef BOOL (^TappedViewBlock)(UIView *view);

@interface MAGFreeSpaceLongTouchDetector : MAGLongTouchDetector

@property (strong, nonatomic) TappedViewBlock shouldRecognizeViewAsFreespaceBlock;

@end
