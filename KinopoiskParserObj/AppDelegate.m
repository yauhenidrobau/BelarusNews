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

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:173/255.0 green:31/255.0 blue:45/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],[UIColor whiteColor], nil]];
    
#warning comment
    /*
     почему ты для < 10 в NotificationManager авторизацию запрашиваешь, а для 10 прям здесь вхуярил???
     */
    if ([UIDevice currentDevice].systemVersion.floatValue < 10) {
        [[NotificationManager sharedInstance] enableLocalNotificationsForLowerIOS];
    } else {
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
        }
    }
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
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
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
#warning почему этот метод не в NotificationManager???
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [[Utils getMainController] updateWithIndicator:YES];
#warning почему тут вообще таймер??? почему он не в NotificationManager
    [timer invalidate];
    timer = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#warning Comment

/*
Два одинаковых метода!!! Сделай один и внутри проверяй версию оси
 */

-(void)backgroundRefreshForIOS10 {
    
    [[NotificationManager sharedInstance]shouldCreateNotificalion:^(NSString *alertBody, NSError *error) {
        if (alertBody.length) {
            [[NotificationManager sharedInstance]createNotificationIOS10WithBody:alertBody];
        }
    }];
    
}

-(void)backgroundRefreshForLowerIOS {
    
    [[NotificationManager sharedInstance]shouldCreateNotificalion:^(NSString *alertBody, NSError *error) {
        if (alertBody.length) {
            [[NotificationManager sharedInstance]createNotificationIOSLower10WithBody:alertBody];
        }
    }];
}
@end
