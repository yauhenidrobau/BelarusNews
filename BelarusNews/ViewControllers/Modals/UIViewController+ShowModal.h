/**
 * Extension for UIViewController that allows to show modal view controller
 */

#import <UIKit/UIKit.h>
#import "ModalViewController.h"

@interface UIViewController (ShowModal)

- (void)showModalViewControllerWithIdentifier:(NSString *)storyboardIdentifier;
- (void)showModalViewControllerWithIdentifier:(NSString *)storyboardIdentifier setupBlock:(void (^)(ModalViewController *))setupBlock;
- (void)showModalViewControllerWithIdentifier:(NSString *)storyboardIdentifier setupBlock:(void (^)(ModalViewController *))setupBlock animated:(BOOL)animated;

- (void)hideCurrentModal:(BOOL)animated;

@property (nonatomic, strong) NSMutableArray *modalsQueue;

@property (nonatomic, strong) UIWindow *currentModal;

@end
