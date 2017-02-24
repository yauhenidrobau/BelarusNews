#import "LocationAutoCompleteController.h"

@interface LocationAutoCompleteController () <GMSAutocompleteViewControllerDelegate>

@end

@implementation LocationAutoCompleteController

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    if (!self.didSelectPlace) {
        return;
    }
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
    self.didSelectPlace(place);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
    // nothing to do here
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentInController:(UIViewController *)parentViewController {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [parentViewController presentViewController:acController animated:YES completion:nil];
}

@end
