//
//  Utils.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 09/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "Utils.h"

#import "DateFormatterManager.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "UserDefaultsManager.h"
#import "UIColor+BelarusNews.h"

@implementation Utils

+(void)exitFromApplication {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    exit(0);
}

+(NewsTableView*)getMainController {
    
    NewsTableView *newsTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsTableView"];
    newsTableViewController.urlString = [[UserDefaultsManager sharedInstance] objectForKey:@"CurrentUrl"];
    newsTableViewController.titlesString = [[UserDefaultsManager sharedInstance] objectForKey:@"CurrentTitle"];
    
    return newsTableViewController;
}

+(void)setNightNavigationBar:(UINavigationBar*)navBar {
    [navBar setBarTintColor:[UIColor bn_navBarNightColor]];
    [navBar setTintColor:[UIColor bn_navBarNightTitleColor]];
    [navBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor bn_navBarNightTitleColor]}];
}

+(void)setDefaultNavigationBar:(UINavigationBar*)navBar {
    [navBar setBarTintColor:[UIColor bn_settingsBackgroundColor]];
    [navBar setTintColor:[UIColor bn_navBarTitleColor]];
    [navBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor bn_navBarTitleColor]}];
}

@end

@implementation NSDateFormatter (Localized)

+ (NSDateFormatter *)currentLocalization {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[DateFormatterManager sharedInstance] currentLocale];
    return dateFormatter;
}

@end
