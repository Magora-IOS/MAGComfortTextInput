
#import "MAGScrollViewComfortTextInput.h"
#import "UIView+MAGMore.h"
#import "MAGCommonDefines.h"

@interface MAGScrollViewComfortTextInput ()

@property (assign, nonatomic) UIEdgeInsets scrollViewStartContentInset;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL scrollViewContentInsetChanged;

@end

@implementation MAGScrollViewComfortTextInput

- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView withScrollViewInsideOwnerViewWhereTextFieldsLocated:(UIScrollView *)scrollView {
    self = [super initWithOrderedTextInputControls:orderedTextInputControls withOwnerView:ownerView];
    if (self) {
        _scrollViewStartContentInset = scrollView.contentInset;
        _scrollView = scrollView;
    }
    return self;
}

- (void)resetWithResignFirstResponder {
    [super resetWithResignFirstResponder];
    [self setScrollViewContentInset:self.scrollViewStartContentInset];
    self.scrollViewContentInsetChanged = NO;
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
        [self setScrollViewContentInset:self.scrollViewStartContentInset];
        wself.scrollViewContentInsetChanged = NO;
    }];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)inset {
    self.scrollView.contentInset = inset;
    self.scrollView.scrollIndicatorInsets = inset;
}

#pragma mark - UITextFieldDelegate DELEGATE

- (void)textFieldWillBeginEditing:(UITextField *)textField {
    [self textInputControlWillBeginEditing:textField];
    RUN_BLOCK(self.didTextInputControlStartEditingBlock, textField);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = YES;
    BOOL willCallShouldChangeBlock = result && self.shouldChangeTextInRangeBlock;
    if (willCallShouldChangeBlock) {
        result = self.shouldChangeTextInRangeBlock(textField, range, string);
    }
    return result;
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
            if (self.scrollViewContentInsetChanged) {
                [self performActionsAnimated:^{
                    [self setScrollViewContentInset:self.scrollViewStartContentInset];
                }];
                self.scrollViewContentInsetChanged = NO;
            }
        }
    }
    CGFloat textFieldScreenYPosition = [textField mag_viewOriginAtScreenCoordinates].y;
    //NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

#pragma mark - UITextViewDelegate DELEGATE

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textInputControlWillBeginEditing:textView];
    RUN_BLOCK(self.didTextInputControlStartEditingBlock, textView);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL result = YES;
    BOOL avoidNewLineCharacter = [text isEqualToString:@"\n"];
    if (self.textInputControlShouldChangeFocusOrResignByReturnKeyBlock) {
        BOOL willDoAction = self.textInputControlShouldChangeFocusOrResignByReturnKeyBlock(textView);
        avoidNewLineCharacter = avoidNewLineCharacter && willDoAction;
    }
    if (avoidNewLineCharacter) {
        result = NO;
        [self textInputControlShouldReturn:textView];//     here returned result useless for us
    }
    BOOL willCallShouldChangeBlock = result && self.shouldChangeTextInRangeBlock;
    if (willCallShouldChangeBlock) {
        result = self.shouldChangeTextInRangeBlock(textView, range, text);
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
    if (!self.scrollViewContentInsetChanged) {
        if (increaseContentHeightForScrollView > 0) {
            UIEdgeInsets newContentInset = self.scrollView.contentInset;
            newContentInset.bottom += increaseContentHeightForScrollView;
            [self setScrollViewContentInset:newContentInset];
            self.scrollViewContentInsetChanged = YES;
        }
    }
    
    CGFloat textFieldYtranslatedToScrollView = [textInputControl mag_viewOriginAtViewCoordinates:_scrollView].y;//     bcs it may be textfield inside UITableViewCell, so weneed translate coordinates of it
    CGFloat newContentOffsetY = textFieldYtranslatedToScrollView - (freeHeightFromOwnerViewTopToKeyboardTop/2.0) + (textInputControl.height / 2.0);
    CGFloat maximumContentOffsetY = (_scrollView.contentSize.height + _scrollView.contentInset.bottom) - _scrollView.height;
    if (newContentOffsetY < 0) {
        newContentOffsetY = 0;
    }
    if (newContentOffsetY > maximumContentOffsetY) {
        newContentOffsetY = maximumContentOffsetY;
    }
    
    CGFloat additionalShift = 0;
    if (self.textInputControlAdditionalShiftOnFocusBlock) {
        additionalShift = self.textInputControlAdditionalShiftOnFocusBlock(textInputControl);
    }
    CGFloat modifiedNewContentOffsetY = newContentOffsetY + additionalShift;
    
    if (modifiedNewContentOffsetY < 0) {
        modifiedNewContentOffsetY = 0;
    }
    [self setScrollViewContentOffsetY:modifiedNewContentOffsetY];
}

- (BOOL)textInputControlShouldReturn:(UIView *)textInputControl {
    BOOL result = NO;
    NSUInteger index = [self.orderedTextInputControls indexOfObject:textInputControl];
    if (index != NSNotFound) {
        if (index != self.orderedTextInputControls.count - 1) {
            if (self.textInputControlDidEndEditingBlock) {
                self.textInputControlDidEndEditingBlock(textInputControl);
            }
            BOOL shouldGoNextControl = YES;
            if (self.textInputControlShouldChangeFocusOrResignByReturnKeyBlock) {
                shouldGoNextControl = self.textInputControlShouldChangeFocusOrResignByReturnKeyBlock(textInputControl);
            }
            if (shouldGoNextControl) {
                UITextField *nextTextField = [self.orderedTextInputControls objectAtIndex:index + 1];
                [nextTextField becomeFirstResponder];
            }
        } else {
            if (self.lastTextInputControlDidEndEditingBlock) {
                self.lastTextInputControlDidEndEditingBlock(textInputControl);
            }
            result = YES;
            [self turnToInitialState];
            
            BOOL shouldFinishEditing = YES;
            if (self.textInputControlShouldChangeFocusOrResignByReturnKeyBlock) {
                shouldFinishEditing = self.textInputControlShouldChangeFocusOrResignByReturnKeyBlock(textInputControl);
            }
            if (shouldFinishEditing) {
                [textInputControl resignFirstResponder];
            }
            if (self.scrollViewContentInsetChanged) {
                [self performActionsAnimated:^{
                    [self setScrollViewContentInset:self.scrollViewStartContentInset];
                }];
                self.scrollViewContentInsetChanged = NO;
            }
        }
    }
    CGFloat textFieldScreenYPosition = [textInputControl mag_viewOriginAtScreenCoordinates].y;
    //NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

@end
