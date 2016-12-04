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

@interface RootViewController ()

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
    //    LMRightMenuViewController *rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    //
    // Setup side bar controller
    [self setPanGestureEnabled:YES];
    [self setDelegate:self];
    [self setMenuViewController:leftMenuViewController forDirection:LMSideBarControllerDirectionLeft];
    //    [self setMenuViewController:rightMenuViewController forDirection:LMSideBarControllerDirectionRight];
    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionLeft];
    //    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionRight];
    [self setContentViewController:navigationController];
}


#pragma mark - SIDE BAR DELEGATE

- (void)sideBarController:(LMSideBarController *)sideBarController willShowMenuViewController:(UIViewController *)menuViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController willHideMenuViewController:(UIViewController *)menuViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController
{
    
}

@end
