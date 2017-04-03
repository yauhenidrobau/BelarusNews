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
        UIImage *image = [UIImage imageNamed:@"menuIcon"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
        [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
        [self.view addGestureRecognizer:tap];
        revealViewController.view.backgroundColor = [UIColor whiteColor];
        
    }
}

@end
