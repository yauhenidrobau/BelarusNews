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
#import "Utils.h"
#import "UserDefaultsManager.h"

#define NO_INTERNET_KEY @"NoInternet"

@interface RootViewController ()

@property(nonatomic,strong) NewsTableView *mainViewController;
@property(nonatomic,strong) SettingsVC *settingsVC;
@property(nonatomic,strong) UINavigationController *mainNavigationController;

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
    self.settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
    [self.mainNavigationController setViewControllers:@[leftMenuViewController, self.mainViewController] animated:YES];
    // Setup side bar controller
    [self setPanGestureEnabled:YES];
    [self setDelegate:self];
    [self setMenuViewController:leftMenuViewController forDirection:LMSideBarControllerDirectionLeft];
    //    [self setMenuViewController:rightMenuViewController forDirection:LMSideBarControllerDirectionRight];
    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionLeft];
    //    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionRight];
    [self setContentViewController:self.mainNavigationController];
    [[UserDefaultsManager sharedInstance] setBool:NO ForKey:NO_INTERNET_KEY];

}


#pragma mark - SIDE BAR DELEGATE

- (void)sideBarController:(LMSideBarController *)sideBarController willShowMenuViewController:(UIViewController *)menuViewController {
    [menuViewController viewWillAppear:YES];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didShowMenuViewController:(UIViewController *)menuViewController {
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController willHideMenuViewController:(MenuViewController *)menuViewController {
    [self.mainNavigationController dismissViewControllerAnimated:NO completion:nil];
    if (menuViewController.titleString.length) {
        if ([menuViewController.titleString isEqualToString:NSLocalizedString(@"Profile",nil)]) {
            return;
        } else if ([menuViewController.titleString isEqualToString:NSLocalizedString(@"Favorites",nil)]) {
            self.mainViewController.menuTitle = menuViewController.titleString;
            menuViewController.titleString = @"";
            [self.mainViewController viewWillAppear:YES];
        } else if ([menuViewController.titleString isEqualToString:NSLocalizedString(@"Settings",nil)]) {
            menuViewController.titleString = @"";
            [self.mainNavigationController pushViewController:self.settingsVC animated:YES];
        } else if ([menuViewController.titleString isEqualToString:NSLocalizedString(@"Log out",nil)]) {
            menuViewController.titleString = @"";
            [Utils exitFromApplication];
        }
    } else {
        NSString *titleString = self.mainViewController.titlesString;
        [self.mainViewController viewDidLoad];
        self.mainViewController.titlesString = titleString;
        [self.mainViewController viewWillAppear:YES];
    }
}

- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController {
    
}

@end
