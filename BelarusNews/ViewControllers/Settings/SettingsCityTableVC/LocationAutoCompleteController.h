/**
 * Shows autocomplete view controller
 */

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@interface LocationAutoCompleteController : NSObject

@property (nonatomic, strong) void (^didSelectPlace)(GMSPlace *place);

- (void)presentInController:(UIViewController *)parentViewController;

@end
