
#import "MAGKeyboardInfo.h"

@interface MAGKeyboardInfo () {
    NSDictionary *_keyboardInfo;
    
    NSTimeInterval _keyboardAnimationTimeInterval;
    CGFloat _keyboardHeight;
    NSUInteger _keyboardAnimationCurve;
    BOOL _keyboardInfoGathered;
}
@end

@implementation MAGKeyboardInfo

#pragma mark - Class

+ (MAGKeyboardInfo *)sharedInstance {
    static dispatch_once_t once;
    static MAGKeyboardInfo *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[MAGKeyboardInfo alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Life

- (id)init {
    self = [super init];
    if (self) {
        _keyboardInfoGathered = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

#pragma mark - Public

- (void)prepareKeyboardWithMainWindow:(UIWindow *)window {
    UITextField *lagFreeField = [[UITextField alloc] init];
    [window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}

- (NSTimeInterval)keyboardAnimationTimeInterval {
    return _keyboardAnimationTimeInterval;
}

- (CGFloat)keyboardHeight {
    return _keyboardHeight;
}

- (NSUInteger)keyboardAnimationCurve {
    return _keyboardAnimationCurve;
}

- (BOOL)keyboardInfoGathered {
    return _keyboardInfoGathered;
}

#pragma mark - UIKeyboard Notifications

- (void)keyboardNotification:(NSNotification*)notification {
    _keyboardInfoGathered = YES;
    
    _keyboardInfo = [notification userInfo];
     
    NSValue *keyboardAnimationTimeIntervalValue = [_keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [keyboardAnimationTimeIntervalValue getValue:&_keyboardAnimationTimeInterval];
    
    NSValue *keyboardFrameBeginValue = [_keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBegin;
    [keyboardFrameBeginValue getValue:&keyboardFrameBegin];
    if (keyboardFrameBegin.size.height > 1) {//     no save when it will became 0 (when keyboard will hidden)
        _keyboardHeight = keyboardFrameBegin.size.height;
    }
    
    NSValue *keyboardAnimationCurveValue = [_keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [keyboardAnimationCurveValue getValue:&_keyboardAnimationCurve];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
