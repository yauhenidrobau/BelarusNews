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
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:173/255.0 green:31/255.0 blue:45/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],[UIColor whiteColor], nil]];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
    }
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}




- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"NotificationsMode"]){
    timer = [NSTimer scheduledTimerWithTimeInterval:60*20 target:self selector:@selector(backgroundRefresh) userInfo:nil repeats:YES];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [[self getMainController] updateWithIndicator:YES];
    [timer invalidate];
    timer = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

-(void)backgroundRefresh {
    
    NSArray *oldArray = [[RealmDataManager sharedInstance]getObjectsForEntity:[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentTitle"]];
    [[self getMainController] updateWithIndicator:NO];
    NSArray *newArray = [[RealmDataManager sharedInstance]getObjectsForEntity:[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentTitle"]];
    if (newArray.count >= oldArray.count) {
        NSString *alertBody = ((NewsEntity*)newArray[0]).titleFeed;
        UNMutableNotificationContent *localNotification = [[UNMutableNotificationContent alloc] init];
        localNotification.title = [NSString localizedUserNotificationStringForKey:NSLocalizedString(@"Latest news",nil) arguments:nil];
        localNotification.body = [NSString localizedUserNotificationStringForKey:alertBody arguments:nil];
        localNotification.sound = [UNNotificationSound defaultSound];
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger 
                                                  triggerWithTimeInterval:1 repeats:NO];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time Down" content:localNotification trigger:trigger]; UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) { NSLog(@"Add NotificationRequest succeeded!");
            }
        }];
    }
}

- (void)enableLocalNotifications
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound
                                            categories:nil];
    UIApplication *app = [UIApplication sharedApplication];
    
    if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [app registerUserNotificationSettings:settings];
        [app registerForRemoteNotifications];
    }
}

- (void)disablePushNotifications
{
    UIApplication *app = [UIApplication sharedApplication];
    [app unregisterForRemoteNotifications];
}

-(NewsTableView*)getMainController {
    
    NewsTableView *newsTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsTableView"];
    newsTableViewController.urlString = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUrl"];
    newsTableViewController.titlesString = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentTitle"];

    return newsTableViewController;
}

@end
