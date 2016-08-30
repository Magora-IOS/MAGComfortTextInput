
#import "MAGFreeSpaceLongTouchDetector.h"

@implementation MAGFreeSpaceLongTouchDetector

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL result = ![[touch view] isKindOfClass:[UIControl class]] && ![[touch view] isKindOfClass:[UINavigationBar class]];
    //  Should not recognize gesture if the clicked view is either UIControl or UINavigationBar(<Back button etc...)
    return result;
}

@end
