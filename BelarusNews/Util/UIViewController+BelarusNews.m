//
//  UIViewController+BelarusNews.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 3/24/17.
//  Copyright © 2017 Yauheni Drobau. All rights reserved.
//

#import "UIViewController+BelarusNews.h"

#import <SWRevealViewController.h>

@implementation UIViewController (BelarusNews)

- (void)setupRevealViewController {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController && !self.navigationItem.leftBarButtonItem) {
        UIBarButtonItem* revealButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuIcon"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self.revealViewController
                                                                           action:@selector( revealToggle: )];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
        [self.view addGestureRecognizer:tap];
        revealViewController.view.backgroundColor = [UIColor whiteColor];
        
    }
}

@end
