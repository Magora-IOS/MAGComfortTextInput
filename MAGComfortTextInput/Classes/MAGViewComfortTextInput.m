
#import "MAGViewComfortTextInput.h"
#import "UIView+MAGMore.h"
#import "MAGCommonDefines.h"

@interface MAGViewComfortTextInput ()

@end

@implementation MAGViewComfortTextInput

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
    BOOL result = [self textInputControlShouldReturn:textField];
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
    
    CGFloat additionalShift = 0;
    if (self.textInputControlAdditionalShiftOnFocusBlock) {
        additionalShift = self.textInputControlAdditionalShiftOnFocusBlock(textInputControl);
    }
    CGFloat modifiedOwnerViewNewTopY = ownerViewNewTopY + additionalShift;
    
    [self setOwnerViewYanimated:modifiedOwnerViewNewTopY];
    
    BOOL displayDebugLog = NO;
    if (displayDebugLog) {
        NSLog(@"freeHeightFromScreenTopToKeyboardTop %@",@(freeHeightFromScreenTopToKeyboardTop));
        NSLog(@"freeHeightFromOwnerViewTopScreenCoordinatesToKeyboardTop %@",@(freeHeightFromOwnerViewTopScreenCoordinatesToKeyboardTop));
        NSLog(@"verticallyCenteredTextFieldYinScreenCoordinates %@",@(verticallyCenteredTextFieldYinScreenCoordinates));
        NSLog(@"neededOwnerViewShift %@",@(neededOwnerViewShift));
        NSLog(@"neededOwnerViewShift %@",@(neededOwnerViewShift));
        NSLog(@"ownerViewNewTopY %@",@(ownerViewNewTopY));
    }
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
                UIResponder *responder = textInputControl;
                [responder resignFirstResponder];
            }
        }
    }
    CGFloat textFieldScreenYPosition = [textInputControl mag_viewOriginAtScreenCoordinates].y;
    //NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

@end
