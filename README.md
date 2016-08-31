# MAGComfortTextInput
It makes using of UITextField, UITextView much easier by taking up keyboard's displaying behaviour

Supported parent views:
*  UIView
*  UIScrollView (and subclasses, i.e. UITableView)
  
Possibilities:
*  1 Centering of active UITextField / UITextView (aka "InputField") on free space between top of screen and top of appeared keyboard.
*  2 Dismiss by click on empty area
*  3 Action by Next / Done button's pressing
*  4 Easy for addition customization

![](https://github.com/Magora-IOS/MAGComfortTextInput/blob/master/Preview/MAGComfortTextInput.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

`MAGComfortTextInput` works on iOS 7+ (may be 6+, I'm not sure).

## Installation

MAGPdfGenerator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile and run `pod install`:

```ruby
pod 'MAGComfortTextInput'
```

## Usage

For example, you have 3 UITextField and 3 UITextView on your UIView:

```ruby
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextView *tv1;
@property (weak, nonatomic) IBOutlet UITextView *tv2;
@property (weak, nonatomic) IBOutlet UITextView *tv3;

@property (strong, nonatomic) MAGViewComfortTextInput *comfortTextInput;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self configureTextFieldsForConvinientUsing];
    [self.tf1 becomeFirstResponder];
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
```

For UIScrollView as fundament view of your InputFields you should to write like code:

```ruby
- (MAGViewComfortTextInput *)configureTextFieldsForConvinientUsing {
    if (_comfortTextInput) {
        return _comfortTextInput;
    }
    
    _comfortTextInput = [[MAGScrollViewComfortTextInput alloc] initWithOrderedTextInputControls:@[self.tf1,self.tv1,self.tf2,self.tv2,self.tf3,self.tv3 ] withOwnerView:self.view withScrollViewInsideOwnerViewWhereTextFieldsLocated:self.scrollView];
    _comfortTextInput.textInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        NSLog(@"DO SOMETHING");
    };
    _comfortTextInput.lastTextInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        NSLog(@"DO SOMETHING ON FINISH");
    };
    return _comfortTextInput;
}
```

## Author

Denis Matveev, matveev@magora-systems.com

## License

See the LICENSE file for more info.
