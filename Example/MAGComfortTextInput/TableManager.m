








#import "TableManager.h"
#import "Cell.h"
#import "NSObject+MAGMore.h"

@implementation TableManager

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    return [Cell mag_className];
}

- (NSArray *)cellClassNamesForNibOrClassRegistering {
    return @[[Cell mag_className]];
}

- (void)configureCell:(Cell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    cell.tf.text = @(indexPath.row).stringValue;
//    RCProject *project = (RCProject *)item;
//    cell.project = project;
}

@end
