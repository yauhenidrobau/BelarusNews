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
#import "DataManager.h"
#import <Google/Analytics.h>

@import GooglePlaces;

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];

    [GMSPlacesClient provideAPIKey:GOOGLE_PLACES_KEY];
    
    [self enableGoogleAnalytics];
    
    [[DataManager sharedInstance] updateWeatherForecastWithCallback:^(CityObject *cityObject, NSError *error) {
    }];
    
    [[NotificationManager sharedInstance] registerForPushNotificationsWithApplication:application];
    application.applicationIconBadgeNumber = 0;
    
    [YMPYandexMetricaPush handleApplicationDidFinishLaunchingWithOptions:launchOptions];
    [YMMYandexMetrica activateWithApiKey:YANDEX_METRICE_API_KEY];
    
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

#pragma mark - Private 

-(void)enableGoogleAnalytics {
    
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].dispatchInterval = 20;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-80107844-2"];
    [GAI sharedInstance].defaultTracker = tracker;
    tracker.allowIDFACollection = YES;
}
@end
