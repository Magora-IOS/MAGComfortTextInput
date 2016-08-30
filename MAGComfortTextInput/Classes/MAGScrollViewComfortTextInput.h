
#import "MAGBaseComfortTextInput.h"

/**!     @class Class for comfortable input data into textfields which located at scrollview which located on view (or any subview) of some viewcontroller
         @warn Not forget to init KeyboardInfo. See KeyboardInfo for it
 */
@interface MAGScrollViewComfortTextInput : MAGBaseComfortTextInput

- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView withScrollViewInsideOwnerViewWhereTextFieldsLocated:(UIScrollView *)scrollView;

@end
