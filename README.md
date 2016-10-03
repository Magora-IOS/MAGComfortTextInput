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

## WARNING

For testing on iOS Simulator you have to enable displaying of keyboard. For doing this open iOS Simulator -> Hardware -> Keyboard -> Connect Hardware Keyboard / Toggle software keyboard. (here CMD + K / CMD + SHIFT + K combinations)

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

You should prepare MAGKeyboardInfo before [self.window makeKeyAndVisible] in AppDelegate.m. If you create your windows manually, then do this after creation of this. For example:

```ruby
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
...
[[MAGKeyboardInfo sharedInstance] prepareKeyboardWithMainWindow:self.window];
[self.window makeKeyAndVisible];
...
}
```

Else, if you use launch screen, then call this method at first after your window's creation! 

So, for example, you have 3 UITextField and 3 UITextView in UIView of your UIViewController:

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
```

If, for example, you have 3 UITextField and 3 UITextView in UIScrollView (or UITableView) of your UIViewController, then change initialization code on the next:

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
