
#import "MAGFreeSpaceLongTouchDetector.h"

@implementation MAGFreeSpaceLongTouchDetector

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL result;
    UIView *tappedView = [touch view];
    result = ![tappedView isKindOfClass:[UIControl class]] && ![tappedView isKindOfClass:[UINavigationBar class]];
    //  Should not recognize gesture if the clicked view is either UIControl or UINavigationBar(<Back button etc...)
    if (self.shouldRecognizeViewAsFreespaceBlock) {
        BOOL should = self.shouldRecognizeViewAsFreespaceBlock(tappedView);
        result = result && should;
    }
    return result;
}

@end
