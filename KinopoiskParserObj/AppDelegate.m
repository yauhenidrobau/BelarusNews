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

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0 / 255.0 green:255.0 / 255.0 blue:184.0/ 255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],[UIColor whiteColor], nil]];
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
#warning Comment 
    /*
     Я тебя просто придушу за такой код!!!
     1. Какие юзер дефолтс по приложению??????? Сделай какой-нибудь менеджер для этого всего и вызови один метод, типа isNotificatonsEnable
     2. Почему клюс "NotificationsMode" строкой используешь??? Почему не в константах???
     3. Что за копи-паст???? Зачем вообще здесь проверка на иос 10? Почему не сделать один метод refreshDataInBackground и там сделать проверку на версию оси. А что будет с выходом иос 11? Ты здесь еще одну проверку впилишь???
     */
    if([defaults boolForKey:@"NotificationsMode"]) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 10) {
            timer = [NSTimer scheduledTimerWithTimeInterval:60*20 target:self selector:@selector(backgroundRefreshForLowerIOS) userInfo:nil repeats:YES];
        } else {
            timer = [NSTimer scheduledTimerWithTimeInterval:60*20 target:self selector:@selector(backgroundRefreshForIOS10) userInfo:nil repeats:YES];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NotificationManager sharedInstance] cancellAllNotifications];
    [[Utils getMainController] updateWithIndicator:YES];
#warning почему тут вообще таймер??? почему он не в NotificationManager
    [timer invalidate];
    timer = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)backgroundRefresh {
    
    [[NotificationManager sharedInstance]shouldCreateNotificalion:^(NSString *alertBody, NSError *error) {
        if (alertBody.length) {
            if ([[UIDevice currentDevice]systemVersion].integerValue < 10) {
                [[NotificationManager sharedInstance]createNotificationIOSLower10WithBody:alertBody];
            } else
            [[NotificationManager sharedInstance]createNotificationIOS10WithBody:alertBody];
        }
    }];
}

@end
