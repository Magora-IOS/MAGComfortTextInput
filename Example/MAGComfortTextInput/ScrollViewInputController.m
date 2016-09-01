








#import "ScrollViewInputController.h"
#import "UIView+MAGMore.h"
#import "MAGScrollViewComfortTextInput.h"

@interface ScrollViewInputController ()

@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextView *tv1;
@property (weak, nonatomic) IBOutlet UITextView *tv2;
@property (weak, nonatomic) IBOutlet UITextView *tv3;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) MAGScrollViewComfortTextInput *comfortTextInput;

@end

@implementation ScrollViewInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ScrollViewInputController";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureTextFieldsForConvinientUsing];
    [self.tf1 becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.comfortTextInput resetWithResignFirstResponder];
}

- (MAGScrollViewComfortTextInput *)configureTextFieldsForConvinientUsing {
    if (_comfortTextInput) {
        return _comfortTextInput;
    }
    
    _comfortTextInput = [[MAGScrollViewComfortTextInput alloc] initWithOrderedTextInputControls:@[self.tf1,self.tv1,self.tf2,self.tv2,self.tf3,self.tv3 ] withOwnerView:self.view withScrollViewInsideOwnerViewWhereTextFieldsLocated:self.scrollView];
    _comfortTextInput.lastTextInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
    
    };
    return _comfortTextInput;
}

@end
