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
#import <UIKit/UIDevice.h>
#import "NotificationManager.h"
#import "Utils.h"
#import "Constants.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import <YandexMobileMetricaPush/YandexMobileMetricaPush.h>
#import "UserDefaultsManager.h"
#import "Constants.h"
#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"

@import GooglePlaces;

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];

    [GMSPlacesClient provideAPIKey:@"AIzaSyB6SYasED7O-tRz3zEPRwHf846Q6DZfjYg"];

    
    [YMMYandexMetrica activateWithApiKey:YANDEX_METRICE_API_KEY];
    [[NotificationManager sharedInstance] registerForPushNotificationsWithApplication:application];
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [YMPYandexMetricaPush setDeviceTokenFromData:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {

    [YMPYandexMetricaPush handleRemoteNotification:userInfo];
    
    // Get user data from remote notification.
    NSString *userData = [YMPYandexMetricaPush userDataForNotification:userInfo];
    NSLog(@"User Data: '%@'", userData);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    if ([[UserDefaultsManager sharedInstance] boolForKey:NOTIFICATIONS_MODE]) {
        [[NotificationManager sharedInstance]startMonitoring];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NotificationManager sharedInstance] cancellAllNotifications];
    [[Utils getMainController] updateWithIndicator:YES];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
