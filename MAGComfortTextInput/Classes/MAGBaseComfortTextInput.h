
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "MAGKeyboardInfo.h"
#import "MAGFreeSpaceLongTouchDetector.h"
typedef void(^TextInputBlock)(UIView *textInputControl);
typedef BOOL(^TextInputCheckBlock)(UIView *textInputControl);
typedef CGFloat(^TextInputShiftBlock)(UIView *textInputControl);
typedef BOOL(^ShouldChangeTextInRangeBlock)(UIView *textInputControl, NSRange range, NSString *replacementText);


/**
        @warn !!! you should create it single time per view controller (but you may have some BaseComfortTextInput's per view controller - so init every of it single time for avoid very strange bugs (not settable cursor at textfields, captured previous created BaseComfortTextInput, or not displaying magnifier by long tap at this textfields, etc)
        @warn you should init it when frame of your ownerView calculated and was set (so it located at expected location for example under status + navigation bars). Else behavior of it will wrong. So you should init it after status + navigation bars layouted yet (in viewDidAppear)
 */
@interface MAGBaseComfortTextInput : NSObject <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSArray *orderedTextInputControls;
@property (strong, nonatomic) UIView *ownerView;
@property (assign, nonatomic, readonly) CGRect ownerViewStartFrame;
@property (assign, nonatomic, readonly) CGRect ownerViewScreenStartFrame;

@property (strong, nonatomic) NSNumber *lastControlReturnKeyType;// @(UIReturnKeyType)

@property (nonatomic) BOOL hideKeyboardOnTapOutside;


@property (strong, nonatomic) ShouldChangeTextInRangeBlock shouldChangeTextInRangeBlock;

@property (strong, nonatomic) TextInputBlock didTextInputControlTextChangedBlock;
@property (strong, nonatomic) TextInputBlock didTextInputControlStartEditingBlock;
@property (strong, nonatomic) TextInputBlock textInputControlDidEndEditingBlock;
@property (strong, nonatomic) TextInputBlock lastTextInputControlDidEndEditingBlock;

@property (strong, nonatomic) TextInputCheckBlock textInputControlShouldChangeFocusOrResignByReturnKeyBlock;//       when return NO for some control, then pressing of return key on this, will be added newline symbol!
@property (strong, nonatomic) TextInputShiftBlock textInputControlAdditionalShiftOnFocusBlock;//       when return NO for some control, then

@property (strong, nonatomic) TappedViewBlock shouldRecognizeViewAsFreespaceBlock;

//!     @param      orderedTextInputControls is controls, numbered in right order of changing focus by Next button of keyboard, which may be just UITextField or UITextView
- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView;
- (void)resetWithResignFirstResponder;

- (void)updateOrderedTextInputControls:(NSArray *)orderedTextInputControls;

- (void)recenterCurrentFocusedTextInputControlItem:(UIView *)textInputControl;

//      for using just from subclasses:
- (void)turnToInitialState;
- (void)setOwnerViewYanimated:(CGFloat)newY;
- (void)performActionsAnimated:(dispatch_block_t)block;

- (void)textFieldWillBeginEditing:(UITextField *)textField;//       should be rewritten in subclass


@end
