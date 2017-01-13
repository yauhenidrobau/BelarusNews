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

@implementation Utils

+(void)exitFromApplication {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    exit(0);
}

+(NewsTableView*)getMainController {
    
    NewsTableView *newsTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsTableView"];
    newsTableViewController.urlString = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUrl"];
    newsTableViewController.titlesString = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentTitle"];
    
    return newsTableViewController;
}


@end

@implementation NSDateFormatter (Localized)

+ (NSDateFormatter *)newLocalized
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[DateFormatterManager sharedInstance] currentLocale];
    return dateFormatter;
}

@end
