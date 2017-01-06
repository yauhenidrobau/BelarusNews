//
//  AppDelegate.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "NewsTableView.h"
#import "RealmDataManager.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:173/255.0 green:31/255.0 blue:45/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],[UIColor whiteColor], nil]];
    
//    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (locationNotification) {
//        application.applicationIconBadgeNumber = 0;
//    }
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    UILocalNotification *localNotif = [launchOptions
                                       objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotif) {
        // has notifications
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"NotificationsMode"];
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(backgroundRefresh) userInfo:nil repeats:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NotificationsMode"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[self getMainController] updateWithIndicator:YES];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [timer invalidate];
    timer = nil;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

-(void)backgroundRefresh {
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 1) {
        NSArray *oldArray = [[RealmDataManager sharedInstance]getAllOjbects];
        [[self getMainController] updateWithIndicator:NO];
        NSArray *newArray = [[RealmDataManager sharedInstance]getAllOjbects];
        if (newArray.count >= oldArray.count) {
            NSString *alertBody = ((NewsEntity*)newArray.lastObject).titleFeed;
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
            localNotification.alertBody = alertBody;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
}

-(NewsTableView*)getMainController {
    
    NewsTableView *newsTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsTableView"];
    NSString *temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUrl"];
    newsTableViewController.urlString = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUrl"];
    newsTableViewController.titlesString = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentTitle"];

    return newsTableViewController;
}

@end
