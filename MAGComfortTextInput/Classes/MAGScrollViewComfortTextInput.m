
#import "MAGScrollViewComfortTextInput.h"
#import "UIView+MAGMore.h"

@interface MAGScrollViewComfortTextInput ()

@property (assign, nonatomic) CGSize scrollViewStartContentSize;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL scrollViewContentSizeChanged;

@end

@implementation MAGScrollViewComfortTextInput

- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView withScrollViewInsideOwnerViewWhereTextFieldsLocated:(UIScrollView *)scrollView {
    self = [super initWithOrderedTextInputControls:orderedTextInputControls withOwnerView:ownerView];
    if (self) {
        _scrollViewStartContentSize = scrollView.contentSize;
        _scrollView = scrollView;
    }
    return self;
}

- (void)resetWithResignFirstResponder {
    [super resetWithResignFirstResponder];
    _scrollView.contentSize = _scrollViewStartContentSize;
    _scrollViewContentSizeChanged = NO;
}

- (void)setScrollViewContentOffsetY:(CGFloat)newY {
    __typeof__(self) __weak wself = self;
    [self performActionsAnimated:^{
        wself.scrollView.contentOffset = CGPointMake(wself.scrollView.contentOffset.x, newY);
    }];
}

- (void)turnToInitialState {
    [super turnToInitialState];
    __typeof__(self) __weak wself = self;
    [self performActionsAnimated:^{
        wself.scrollView.contentSize = _scrollViewStartContentSize;
        wself.scrollViewContentSizeChanged = NO;
    }];
}

#pragma mark - UITextFieldDelegate DELEGATE

- (void)textFieldWillBeginEditing:(UITextField *)textField {
    [self textInputControlWillBeginEditing:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = NO;
    NSUInteger index = [self.orderedTextInputControls indexOfObject:textField];
    if (index != NSNotFound) {
        if (index != self.orderedTextInputControls.count - 1) {
            if (self.textInputControlDidEndEditingBlock) {
                self.textInputControlDidEndEditingBlock(textField);
            }
            UITextField *nextTextField = [self.orderedTextInputControls objectAtIndex:index + 1];
            [nextTextField becomeFirstResponder];
        } else {
            if (self.lastTextInputControlDidEndEditingBlock) {
                self.lastTextInputControlDidEndEditingBlock(textField);
            }
            result = YES;
            [self turnToInitialState];
            [textField resignFirstResponder];
            if (_scrollViewContentSizeChanged) {
                [self performActionsAnimated:^{
                    _scrollView.contentSize = _scrollViewStartContentSize;
                }];
                _scrollViewContentSizeChanged = NO;
            }
        }
    }
    CGFloat textFieldScreenYPosition = [textField mag_viewOriginAtScreenCoordinates].y;
    NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

#pragma mark - UITextViewDelegate DELEGATE

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textInputControlWillBeginEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL result = YES;
    if ([text isEqualToString:@"\n"]) {
        result = NO;
        [self textInputControlShouldReturn:textView];//     here returned result useless for us
    }
    return result;
}

#pragma mark - Private

- (void)textInputControlWillBeginEditing:(UIView *)textInputControl {
    CGFloat mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat keyboardHeight = [[MAGKeyboardInfo sharedInstance] keyboardHeight];
    
    //      will center text field on free space
    CGFloat freeHeightFromOwnerViewTopToKeyboardTop = mainScreenHeight - self.ownerViewStartFrame.origin.y - keyboardHeight;
    
    CGFloat scrollViewTopYinsideOwnerView = [_scrollView mag_viewOriginAtViewCoordinates:self.ownerView].y;
    
    //      so raise ownerView for scrollView become stay on top
    CGFloat ownerViewNewTopY = self.ownerViewStartFrame.origin.y - scrollViewTopYinsideOwnerView;
    [self setOwnerViewYanimated:ownerViewNewTopY];//        set y of owner view so, that scrollView will has Y screen coordinate as 0 (that is, we can see top of scrollView frame)
    
    CGFloat increaseContentHeightForScrollView = _scrollView.height - freeHeightFromOwnerViewTopToKeyboardTop;
    if (!_scrollViewContentSizeChanged) {
        if (increaseContentHeightForScrollView > 0) {
            CGSize contentSize = _scrollView.contentSize;
            contentSize.height += increaseContentHeightForScrollView;
            _scrollView.contentSize = contentSize;
            _scrollViewContentSizeChanged = YES;
        }
    }
    
    CGFloat textFieldYtranslatedToScrollView = [textInputControl mag_viewOriginAtViewCoordinates:_scrollView].y;//     bcs it may be textfield inside UITableViewCell, so weneed translate coordinates of it
    CGFloat newContentOffsetY = textFieldYtranslatedToScrollView - (freeHeightFromOwnerViewTopToKeyboardTop/2.0) + (textInputControl.height / 2.0);
    CGFloat maximumContentOffsetY = _scrollView.contentSize.height - _scrollView.height;
    if (newContentOffsetY < 0) {
        newContentOffsetY = 0;
    }
    if (newContentOffsetY > maximumContentOffsetY) {
        newContentOffsetY = maximumContentOffsetY;
    }
    
    [self setScrollViewContentOffsetY:newContentOffsetY];
}

- (BOOL)textInputControlShouldReturn:(UIView *)textInputControl {
    BOOL result = NO;
    NSUInteger index = [self.orderedTextInputControls indexOfObject:textInputControl];
    if (index != NSNotFound) {
        if (index != self.orderedTextInputControls.count - 1) {
            if (self.textInputControlDidEndEditingBlock) {
                self.textInputControlDidEndEditingBlock(textInputControl);
            }
            UITextField *nextTextField = [self.orderedTextInputControls objectAtIndex:index + 1];
            [nextTextField becomeFirstResponder];
        } else {
            if (self.lastTextInputControlDidEndEditingBlock) {
                self.lastTextInputControlDidEndEditingBlock(textInputControl);
            }
            result = YES;
            [self turnToInitialState];
            [textInputControl resignFirstResponder];
            if (_scrollViewContentSizeChanged) {
                [self performActionsAnimated:^{
                    _scrollView.contentSize = _scrollViewStartContentSize;
                }];
                _scrollViewContentSizeChanged = NO;
            }
        }
    }
    CGFloat textFieldScreenYPosition = [textInputControl mag_viewOriginAtScreenCoordinates].y;
    NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

@end
