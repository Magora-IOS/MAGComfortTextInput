
#import "MAGViewComfortTextInput.h"
#import "UIView+MAGMore.h"

@interface MAGViewComfortTextInput ()


@end

@implementation MAGViewComfortTextInput

#pragma mark - UITextFieldDelegate DELEGATE

- (void)textFieldWillBeginEditing:(UITextField *)textField {
    [self textInputControlWillBeginEditing:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = [self textInputControlShouldReturn:textField];
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
    CGFloat textFieldScreenYPosition = [textInputControl mag_viewOriginAtScreenCoordinates].y;
    CGFloat keyboardHeight = [[MAGKeyboardInfo sharedInstance] keyboardHeight];
    
    //      will center text field on free space
    CGFloat freeHeightFromScreenTopToKeyboardTop = mainScreenHeight - keyboardHeight;
    CGFloat freeHeightFromOwnerViewTopScreenCoordinatesToKeyboardTop = freeHeightFromScreenTopToKeyboardTop - self.ownerViewScreenStartFrame.origin.y;
    
    CGFloat verticallyCenteredTextFieldYinScreenCoordinates = (freeHeightFromOwnerViewTopScreenCoordinatesToKeyboardTop / 2.0) - (textInputControl.height / 2.0);
    
    CGFloat neededOwnerViewShift = verticallyCenteredTextFieldYinScreenCoordinates - textFieldScreenYPosition + self.ownerViewScreenStartFrame.origin.y;
    
    CGFloat ownerViewNewTopY = self.ownerView.y + neededOwnerViewShift;
    if (ownerViewNewTopY > self.ownerViewStartFrame.origin.y) {
        ownerViewNewTopY = self.ownerViewStartFrame.origin.y;
    }
    CGFloat ownerViewNewBottomY = ownerViewNewTopY + self.ownerView.height;
    
    CGFloat maximumOwnerViewNewBottomY = freeHeightFromScreenTopToKeyboardTop;
    if (ownerViewNewBottomY < maximumOwnerViewNewBottomY) {
        ownerViewNewTopY = maximumOwnerViewNewBottomY - self.ownerView.height;
    }
    
    [self setOwnerViewYanimated:ownerViewNewTopY];
    NSLog(@"freeHeightFromScreenTopToKeyboardTop %@",@(freeHeightFromScreenTopToKeyboardTop));
    NSLog(@"freeHeightFromOwnerViewTopScreenCoordinatesToKeyboardTop %@",@(freeHeightFromOwnerViewTopScreenCoordinatesToKeyboardTop));
    NSLog(@"verticallyCenteredTextFieldYinScreenCoordinates %@",@(verticallyCenteredTextFieldYinScreenCoordinates));
    NSLog(@"neededOwnerViewShift %@",@(neededOwnerViewShift));
    NSLog(@"neededOwnerViewShift %@",@(neededOwnerViewShift));
    NSLog(@"ownerViewNewTopY %@",@(ownerViewNewTopY));
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
            UIResponder *responder = textInputControl;
            [responder resignFirstResponder];
        }
    }
    CGFloat textFieldScreenYPosition = [textInputControl mag_viewOriginAtScreenCoordinates].y;
    NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

@end
