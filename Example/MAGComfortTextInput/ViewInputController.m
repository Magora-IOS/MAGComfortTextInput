








#import "ViewInputController.h"
#import "MAGViewComfortTextInput.h"
//#import "MAGComfortTextInput_umbrella.h"
#import "UIView+MAGMore.h"
#import "ScrollViewInputController.h"
#import "TableViewInputController.h"

@interface ViewInputController ()

@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextView *tv1;
@property (weak, nonatomic) IBOutlet UITextView *tv2;
@property (weak, nonatomic) IBOutlet UITextView *tv3;

@property (strong, nonatomic) MAGViewComfortTextInput *comfortTextInput;

@end

@implementation ViewInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ViewInputController";
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

- (MAGViewComfortTextInput *)configureTextFieldsForConvinientUsing {
    if (_comfortTextInput) {
        return _comfortTextInput;
    }
    
    _comfortTextInput = [[MAGViewComfortTextInput alloc] initWithOrderedTextInputControls:@[self.tf1,self.tv1,self.tf2,self.tv2,self.tf3,self.tv3 ] withOwnerView:self.view];
    _comfortTextInput.textInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        NSLog(@"DO SOMETHING");
    };
    _comfortTextInput.lastTextInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        NSLog(@"DO SOMETHING ON FINISH");
    };
    return _comfortTextInput;
}


- (IBAction)scrollViewAction {
    ScrollViewInputController *vc = [[ScrollViewInputController alloc] initWithNibName:@"ScrollViewInputController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tableViewAction {
    TableViewInputController *vc = [[TableViewInputController alloc] initWithNibName:@"TableViewInputController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
