//
//  RootViewController.m
//  KinopoiskParserObj
//
//  Created by Admin on 03/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "RootViewController.h"
#import <LMSideBarStyle.h>
#import <LMSideBarController.h>
#import "UIViewController+LMSideBarController.h"
#import <LMSideBarDepthStyle.h>
#import "MenuViewController.h"
#import "NewsTableView.h"

@interface RootViewController ()
@property(nonatomic,strong) NewsTableView *mainViewController;

@end

@implementation RootViewController

#pragma mark - VIEW LIFECYCLE
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Init side bar styles
    LMSideBarDepthStyle *sideBarDepthStyle = [LMSideBarDepthStyle new];
    sideBarDepthStyle.menuWidth = 220;
    
    // Init view controllers
    MenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsTableView"];
    self.mainNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    [self.mainNavigationController setViewControllers:@[leftMenuViewController, self.mainViewController] animated:YES];
    self.mainViewController.title = @"All News";
    // Setup side bar controller
    [self setPanGestureEnabled:YES];
    [self setDelegate:self];
    [self setMenuViewController:leftMenuViewController forDirection:LMSideBarControllerDirectionLeft];
    //    [self setMenuViewController:rightMenuViewController forDirection:LMSideBarControllerDirectionRight];
    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionLeft];
    //    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionRight];
    [self setContentViewController:self.mainNavigationController];
}


#pragma mark - SIDE BAR DELEGATE

- (void)sideBarController:(LMSideBarController *)sideBarController willShowMenuViewController:(UIViewController *)menuViewController {
}

- (void)sideBarController:(LMSideBarController *)sideBarController didShowMenuViewController:(UIViewController *)menuViewController {
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController willHideMenuViewController:(UIViewController *)menuViewController {
//    self.prefersStatusBarHidden = NO;
    self.mainViewController.urlIdentificator = menuViewController.title;
    [self.mainViewController viewDidLoad];
    [self.mainViewController viewWillAppear:YES];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController {
    
}

@end
