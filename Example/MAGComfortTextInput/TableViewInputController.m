








#import "TableViewInputController.h"
#import "RCTableManager.h"
#import "MAGScrollViewComfortTextInput.h"
#import "Cell.h"

@interface TableViewInputController ()

@property (strong, nonatomic) IBOutlet RCTableManager *tm;

@property (strong, nonatomic) MAGScrollViewComfortTextInput *comfortTextInput;

@end

@implementation TableViewInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tm setItems:@[@"1",@"1",@"1",@"1",@"1",
                        @"1",@"1",@"1",@"1",@"1",
                        @"1",@"1",@"1",@"1",@"1",
                        @"1",@"1",@"1",@"1",@"1",
                        ]];
    @weakify(self);
    self.tm.didTableViewScrollBlock = ^() {
        @strongify(self);
        NSArray *cells = [self.tm.tableView visibleCells];
        NSArray *textFields = [cells valueForKeyPath:@"tf"];
        [self.comfortTextInput updateOrderedTextInputControls:textFields];
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureTextFieldsForConvinientUsing];
    [[self.comfortTextInput.orderedTextInputControls firstObject] becomeFirstResponder];
}

- (MAGScrollViewComfortTextInput *)configureTextFieldsForConvinientUsing {
    NSArray *cells = [self.tm.tableView visibleCells];
    NSArray *textFields = [cells valueForKeyPath:@"tf"];
    _comfortTextInput = [[MAGScrollViewComfortTextInput alloc] initWithOrderedTextInputControls:textFields withOwnerView:self.view withScrollViewInsideOwnerViewWhereTextFieldsLocated:self.tm.tableView];
    
    _comfortTextInput.lastTextInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        UITextField *tf = (UITextField *)textInputControl;
        tf.text = @"Last item edited";
    };
    @weakify(self);
    _comfortTextInput.textInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        @strongify(self);
        UITextField *tf = (UITextField *)textInputControl;
        self.title = [NSString stringWithFormat:@"%@ item edited",tf.text];
    };
    return _comfortTextInput;
}

@end