#import "UIViewController+ShowModal.h"

#import <objc/runtime.h>

#import "AppDelegate.h"

@implementation UIViewController (ShowModal)

@dynamic modalsQueue;
@dynamic currentModal;

- (void)setModalsQueue:(NSMutableArray *)queue {
    objc_setAssociatedObject(self, @selector(modalsQueue), queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)modalsQueue {
    NSMutableArray *modalsQueue = objc_getAssociatedObject(self, @selector(modalsQueue));
    if (!modalsQueue) { // lazy instantiation
        modalsQueue = [NSMutableArray array];
        self.modalsQueue = modalsQueue;
    }
    
    return modalsQueue;
}

- (void)setCurrentModal:(UIWindow *)currentModal {
    objc_setAssociatedObject(self, @selector(currentModal), currentModal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)currentModal {
    UIWindow *currentModal = objc_getAssociatedObject(self, @selector(currentModal));
    return currentModal;
}

- (void)showModalViewControllerWithIdentifier:(NSString *)storyboardIdentifier
{
    [self showModalViewControllerWithIdentifier:storyboardIdentifier setupBlock:nil];
}

- (void)showModalViewControllerWithIdentifier:(NSString *)storyboardIdentifier setupBlock:(void (^)(ModalViewController*))setupBlock
{
    [self showModalViewControllerWithIdentifier:storyboardIdentifier setupBlock:setupBlock animated:YES];
}

- (void)showModalViewControllerWithIdentifier:(NSString *)storyboardIdentifier setupBlock:(void (^)(ModalViewController *))setupBlock animated:(BOOL)animated
{
    typeof(self) __weak welf = self;
    
    void (^operation)() = ^{
        [welf _showModalViewControllerInStoryboard:[welf modalsStoryboard] withIdentifier:storyboardIdentifier setupBlock:setupBlock animated:animated];
    };
    [self.modalsQueue addObject:operation];
    
    if (self.modalsQueue.count == 1) {
        [self nextInQueue];
    }
}

- (UIStoryboard *)modalsStoryboard {
    return [UIStoryboard storyboardWithName:@"Modals" bundle:nil];
}

- (void)_showModalViewControllerInStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)storyboardIdentifier setupBlock:(void (^)(ModalViewController *))setupBlock animated:(BOOL)animated
{
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    if (![viewController isKindOfClass:[ModalViewController class]]) {
        [NSException raise:@"Cannot showModalViewControllerInStoryboard" format:@"ViewController must be subclass of ModalViewController"];
    }
    
    ModalViewController *modalViewController = (ModalViewController *)viewController;
    if (setupBlock) {
        setupBlock (modalViewController);
    }
    
    BOOL overStatusBar = modalViewController.shouldBeOverStatusBar;
    
    CGRect screenFrame = UIScreen.mainScreen.bounds;
    
    UIWindow __block *modal = [[UIWindow alloc] initWithFrame:screenFrame];
    modal.windowLevel = overStatusBar ? UIWindowLevelStatusBar : UIWindowLevelNormal;
    modal.backgroundColor = [UIColor clearColor];
    
    self.currentModal = modal;
    
    modalViewController.closeButtonTappedBlock = ^{
        [self hideCurrentModal:animated];
    };
    
    modal.rootViewController = modalViewController;
    [modal makeKeyAndVisible];
        
    if (animated) {
        [self showViewAnimated:modalViewController.view];
    } else {
        modalViewController.view.hidden = NO;
    }
}

- (void)showViewAnimated:(UIView *)view
{
    view.alpha = 0.f;
    view.hidden = NO;
    
    [UIView animateWithDuration:0.125f animations:^{
        view.alpha = 1.f;
    }];
}

- (void)hideViewAnimated:(UIView *)view completed:(void(^)())completed
{
    [UIView animateWithDuration:0.2f animations:^{
        view.alpha = 0.f;
    } completion:^(BOOL finished) {
        view.hidden = YES;
        if (completed) completed();
    }];
}

- (void)nextInQueue
{
    if (self.modalsQueue.count == 0) return;
    
    void (^operation)() = [self.modalsQueue objectAtIndex:0];
    operation ();
}

- (void)hideCurrentModal:(BOOL)animated
{
    if (self.modalsQueue.count == 0) return;
        
    UIWindow __weak *modal = self.currentModal;
    
    void (^hideCompletionBlock)() = ^{
        modal.hidden = YES;
        self.currentModal = nil;
        if (self.modalsQueue.count > 0) {
            [self.modalsQueue removeObjectAtIndex:0];
        }
        [self nextInQueue];
    };
    
    if (animated) {
        [self hideViewAnimated:modal completed:hideCompletionBlock];
    }
    else {
        self.currentModal = nil;
        hideCompletionBlock ();
    }
}

@end
