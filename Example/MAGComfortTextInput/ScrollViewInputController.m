








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
    //    self.wantsFullScreenLayout
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureTextFieldsForConvinientUsing];
    [self.tf1 becomeFirstResponder];
}

- (MAGScrollViewComfortTextInput *)configureTextFieldsForConvinientUsing {
    if (_comfortTextInput) {
        return _comfortTextInput;
    }
    
    _comfortTextInput = [[MAGScrollViewComfortTextInput alloc] initWithOrderedTextInputControls:@[self.tf1,self.tv1,self.tf2,self.tv2,self.tf3,self.tv3 ] withOwnerView:self.view withScrollViewInsideOwnerViewWhereTextFieldsLocated:self.scrollView];
    //    @weakify(self);
    _comfortTextInput.lastTextInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        //        @strongify(self);
        //        [self loginAction];
    };
    return _comfortTextInput;
}

@end
