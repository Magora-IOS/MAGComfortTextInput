
#import "MAGBaseComfortTextInput.h"
#import "MAGFreeSpaceLongTouchDetector.h"
#import "UIView+MAGMore.h"

@interface MAGBaseComfortTextInput ()

@property (strong, nonatomic) MAGFreeSpaceLongTouchDetector *tapDetector;

@end

@implementation MAGBaseComfortTextInput

- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView {
    self = [super init];
    if (self) {
        [ownerView mag_relayout];
        for (NSInteger i = 0; i < orderedTextInputControls.count; ++i) {
            UIView *control = orderedTextInputControls[i];
            [control mag_relayout];
        }
        
        self.ownerView = ownerView;
        _ownerViewStartFrame = ownerView.frame;
        _ownerViewScreenStartFrame = [ownerView mag_viewFrameAtScreenCoordinates];
        _hideKeyboardOnTapOutside = YES;
        [self updateOrderedTextInputControls:orderedTextInputControls];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction) name:UIKeyboardWillHideNotification object:nil];
        
        _tapDetector = [MAGFreeSpaceLongTouchDetector new];
        _tapDetector.minimumRequiredPressDuration = @(0);
        [_tapDetector attachToTargetView:ownerView];
        __typeof__(self) __weak wself = self;
        _tapDetector.didFinishedWithTouchUpAtTargetViewLocationBlock = ^(CGPoint point) {
            CGPoint tappedScreenPoint = [wself.ownerView convertPoint:point toView:nil];
//            NSLog(@"POINT %@ TRANSLATED %@",NSStringFromCGPoint(point),NSStringFromCGPoint(tappedScreenPoint));
//            for (UITextField *currentTextField in wself.orderedTextFields) {
//                CGRect translatedRect = [currentTextField viewFrameAtScreenCoordinates];
//                NSLog(@"current textfield text %@ translated to window rect %@",currentTextField.text,NSStringFromCGRect(translatedRect));
//            }
            if ([wself.ownerView mag_hasFirstResponder]) {
                if (wself.hideKeyboardOnTapOutside) {
                    BOOL someTextFieldContainsPoint = NO;
                    for (UITextField *currentTextField in wself.orderedTextInputControls) {
                        CGRect textFieldScreenFrame = [currentTextField mag_viewFrameAtScreenCoordinates];
                        if (CGRectContainsPoint(textFieldScreenFrame, tappedScreenPoint)) {
                            someTextFieldContainsPoint = YES;
                            break;
                        }
                    }
                    if (!someTextFieldContainsPoint) {
                        [wself hideKeyboard];
                    }
                }
            }
        };

    }
    return self;
}

- (void)updateOrderedTextInputControls:(NSArray *)orderedTextInputControls {
    for (NSInteger i = 0; i < orderedTextInputControls.count - 1; ++i) {
        id<UITextInputTraits> control = orderedTextInputControls[i];
        control.returnKeyType = UIReturnKeyNext;
    }
    id<UITextInputTraits> lastControl = orderedTextInputControls[orderedTextInputControls.count - 1];
    lastControl.returnKeyType = UIReturnKeyDone;
    
    for (id currentControl in orderedTextInputControls) {
        if ([currentControl isKindOfClass:[UITextField class]]) {
            UITextField *textField = currentControl;
            textField.delegate = self;
        } else if ([currentControl isKindOfClass:[UITextView class]]) {
            UITextView *textView = currentControl;
            textView.delegate = self;
        }
    }
    self.orderedTextInputControls = orderedTextInputControls;
}

- (void)resetWithResignFirstResponder {
    [self turnToInitialState];//        you should rewrite it in subclasses
    [self hideKeyboard];
}

- (void)keyboardWillHideAction {
    [self turnToInitialState];
}

- (void)turnToInitialState {
    [self setOwnerViewYanimated:self.ownerViewStartFrame.origin.y];
}

- (void)setOwnerViewYanimated:(CGFloat)newY {
    [self performActionsAnimated:^{
        self.ownerView.y = newY;
    }];
}

- (void)performActionsAnimated:(dispatch_block_t)block {
    //!     @warn       dont replace this animation on [UIView animationWithDuration:...] bcs it will work differently: view will disappeared not synchronously with keyboard
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:[[MAGKeyboardInfo sharedInstance] keyboardAnimationTimeInterval]];
    [UIView setAnimationCurve:[[MAGKeyboardInfo sharedInstance] keyboardAnimationCurve]];
    if (block) {
        block();
    }
    [UIView commitAnimations];
}

- (void)hideKeyboard {
    [self.ownerView endEditing:YES];
}

#pragma mark - UITextFieldDelegate DELEGATE

- (void)textFieldWillBeginEditing:(UITextField *)textField {
    //      should be rewritten in subclass
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self textFieldWillBeginEditing:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textInputControlDidEndEditingBlock) {
        self.textInputControlDidEndEditingBlock(textField);
    }
}

#pragma mark - UITextViewDelegate DELEGATE

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //      should be rewritten in subclass
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self textViewDidBeginEditing:textView];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textInputControlDidEndEditingBlock) {
        self.textInputControlDidEndEditingBlock(textView);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
