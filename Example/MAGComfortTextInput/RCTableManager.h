
#import <Foundation/Foundation.h>

#import "RCTableSection.h"
#import "MAGCommonDefines.h"

typedef void (^RCTableItemBlock) (id item);
typedef void (^RCTableItemBlock) (id item);

/**
        @warn TableManager shoudn't contains some of identical section objects at single time!
 */

@interface RCTableManager : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) RCTableItemBlock didSelectedCellWithItemBlock;
@property (copy, nonatomic) RCCellBlock willDisplayNewCellBlock;
@property (copy, nonatomic) dispatch_block_t didTableViewScrollBlock;
@property (copy, nonatomic) NSArray *items;//      for single section
@property (strong, nonatomic) NSArray<RCTableSection *> *sections;

@property (nonatomic) BOOL useSeparatorsZeroInset;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;

- (id)itemByIndexPath:(NSIndexPath *)indexPath;
- (id)itemByCell:(UITableViewCell *)cell;

- (NSArray *)indexPathsOfItem:(id)item inSections:(NSArray <RCTableSection *> *)sections;
- (NSArray <RCTableSection *> *)sectionsContainingItem:(id)item;//      some sections might contains same item

- (void)reloadItemAtIndexPath:(NSIndexPath *)indexPath animation:(UITableViewRowAnimation)animation;

- (void)reloadData;

- (void)selectFirstRowWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)selectAllRowsWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

- (NSArray *)selectedItems;

//      might be override

- (CGFloat)heightForItem:(id)item;
- (CGFloat)heightForHeaderViewOfSection:(RCTableSection *)section;
- (CGFloat)heightForFooterViewOfSection:(RCTableSection *)section;

- (NSString *)headerIdentifierForSection:(RCTableSection *)section;
- (NSString *)footerIdentifierForSection:(RCTableSection *)section;

- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath;
// must be override
- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;//        ! indexPath added bcs different sections can contains same item but display it in different cell types
- (NSArray *)cellClassNamesForNibOrClassRegistering;//        for registering of nib or class (if nib not exists)
- (void)configureCell:(__kindof UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath;//     indexPath added for same reason
- (void)configureHeaderView:(UIView *)view forSection:(RCTableSection *)section;
- (void)configureFooterView:(UIView *)view forSection:(RCTableSection *)section;

@end
