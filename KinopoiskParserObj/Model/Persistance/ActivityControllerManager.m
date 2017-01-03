//
//  ActivityControllerManager.m
//  KinopoiskParserObj
//
//  Created by Admin on 1/3/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "ActivityControllerManager.h"

@interface ActivityControllerManager ()

@property (nonatomic, strong) UIActivityViewController *activityController;
@end
@implementation ActivityControllerManager
SINGLETON(ActivityControllerManager)

-(instancetype)init {
    self = [super init];
    if (self) {
        self.activityController = [UIActivityViewController alloc];
    }
    return self;
}

- (void)presentActivityController:(UIActivityViewController *)activityVC  {
    self.activityController = activityVC;
//    // for iPad: make the presentation a Popover
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//    
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    self.activityController.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
        } else {
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

@end
