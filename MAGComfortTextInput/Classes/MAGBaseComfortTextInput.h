
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "MAGKeyboardInfo.h"

typedef void(^TextInputControlDidEndEditingBlock)(UIView *textInputControl);
typedef void(^LastTextInputControlDidEndEditingBlock)(UIView *textInputControl);

/**
        @warn !!! you should create it single time per view controller (but you may have some BaseComfortTextInput's per view controller - so init every of it single time for avoid very strange bugs (not settable cursor at textfields, captured previous created BaseComfortTextInput, or not displaying magnifier by long tap at this textfields, etc)
        @warn you should init it when frame of your ownerView calculated and was set (so it located at expected location for example under status + navigation bars). Else behavior of it will wrong. So you should init it after status + navigation bars layouted yet (for example at first viewDidLayoutSubviews or viewDidAppear)
 */
@interface MAGBaseComfortTextInput : NSObject <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSArray *orderedTextInputControls;
@property (strong, nonatomic) UIView *ownerView;
@property (assign, nonatomic, readonly) CGRect ownerViewStartFrame;
@property (assign, nonatomic, readonly) CGRect ownerViewScreenStartFrame;

@property (nonatomic) BOOL hideKeyboardOnTapOutside;

@property (strong, nonatomic) TextInputControlDidEndEditingBlock textInputControlDidEndEditingBlock;
@property (strong, nonatomic) LastTextInputControlDidEndEditingBlock lastTextInputControlDidEndEditingBlock;

//!     @param      orderedTextInputControls is controls, numbered in right order of changing focus by Next button of keyboard, which may be just UITextField or UITextView
- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView;
- (void)resetWithResignFirstResponder;

- (void)updateOrderedTextInputControls:(NSArray *)orderedTextInputControls;

- (void)turnToInitialState;
- (void)setOwnerViewYanimated:(CGFloat)newY;
- (void)performActionsAnimated:(dispatch_block_t)block;

- (void)textFieldWillBeginEditing:(UITextField *)textField;//       should be rewritten in subclass


@end
