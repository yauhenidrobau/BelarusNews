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
#import "SettingsVC.h"
#import "NewsTableView.h"

@interface RootViewController ()
@property(nonatomic,strong) NewsTableView *mainViewController;
@property(nonatomic,strong) SettingsVC *settingsVC;

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
    self.mainNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    self.settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];

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
    [self.mainNavigationController dismissViewControllerAnimated:NO completion:nil];
    if ([menuViewController.title isEqualToString:NSLocalizedString(@"Profile",nil)]) {
        return;
    } else if ([menuViewController.title isEqualToString:NSLocalizedString(@"Favorites",nil)]) {
        self.mainViewController.menuTitle = menuViewController.title;
        [self.mainViewController viewDidLoad];
        [self.mainViewController viewWillAppear:YES];
//        [self.mainNavigationController pushViewController:self.mainViewController animated:YES];
    } else if ([menuViewController.title isEqualToString:NSLocalizedString(@"Settings",nil)]) {
        [self.mainNavigationController pushViewController:self.settingsVC animated:YES];
    }
}

- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController {
    
}

@end
