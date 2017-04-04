/**
 * Base class for all modal view controllers
 */
 
#import <UIKit/UIKit.h>

@interface ModalViewController : UIViewController

/**
 * Block is called once "Close" button tapped
 */
@property (nonatomic, strong) void (^closeButtonTappedBlock)();

@property (nonatomic, readonly) BOOL shouldBeOverStatusBar;

@end
