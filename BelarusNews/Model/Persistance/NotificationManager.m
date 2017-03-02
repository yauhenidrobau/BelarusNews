//
//  NotificationManager.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 13/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "NotificationManager.h"

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "RealmDataManager.h"
#import "NewsTableView.h"
#import <UserNotifications/UserNotifications.h>
#import "Utils.h"
#import "UserDefaultsManager.h"

@interface NotificationManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong)  UserDefaultsManager *userDefaults;

@end

@implementation NotificationManager

SINGLETON(NotificationManager)


#pragma mark - Init 

-(id)init {
    self = [super init];
    if (self) {
        self.userDefaults = [UserDefaultsManager sharedInstance];
    }
    return self;
}
#pragma mark - Notifications 

- (void)registerForPushNotificationsWithApplication:(UIApplication *)application {

    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        if (NSClassFromString(@"UNUserNotificationCenter")) {
            // iOS 10.0 and above
            UNAuthorizationOptions options =
            UNAuthorizationOptionAlert |
            UNAuthorizationOptionBadge |
            UNAuthorizationOptionSound;
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
                //
            }];
        }
        else {
            // iOS 8 and iOS 9
            UIUserNotificationType userNotificationTypes =
            UIUserNotificationTypeAlert |
            UIUserNotificationTypeBadge |
            UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
            }
        [application registerForRemoteNotifications];
    } else {
        UNAuthorizationOptions options =
        UNAuthorizationOptionAlert |
        UNAuthorizationOptionBadge |
        UNAuthorizationOptionSound;
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
            //
        }];
    }
}

-(void)shouldCreateNotificalion:(CreateNotificationCallback)completion {
    NSArray *oldArray = [[RealmDataManager sharedInstance]getObjectsForEntity:[self.userDefaults objectForKey:@"CurrentTitle"]];
    [[Utils getMainController] updateWithIndicator:NO];
    NSArray *newArray = [[RealmDataManager sharedInstance]getObjectsForEntity:[self.userDefaults objectForKey:@"CurrentTitle"]];
    if (newArray.count >= oldArray.count) {
        NSString *alertBody = ((NewsEntity*)newArray[0]).titleFeed;
        if (completion) {
            completion(alertBody,nil);
        }
    } else {
        if (completion) {
            completion(nil,nil);
        }
    }
}

-(void)createNotificationIOS10WithBody:(NSString *)body {
    
    NSString *alertBody = body;
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

-(void)createNotificationIOSLower10WithBody:(NSString *)body {
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.alertTitle = NSLocalizedString(@"Latest news",nil);
    localNotification.alertBody = body;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;

    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
}

-(void)cancellAllNotifications {
    [[UNUserNotificationCenter currentNotificationCenter]removeAllDeliveredNotifications];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)startMonitoring {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60*20 target:self selector:@selector(refreshDataInBackground) userInfo:nil repeats:YES];
}

-(void)refreshDataInBackground {
    
    [self shouldCreateNotificalion:^(NSString *alertBody, NSError *error) {
        if (alertBody.length) {
            if ([[UIDevice currentDevice]systemVersion].integerValue < 10) {
                [self createNotificationIOSLower10WithBody:alertBody];
            } else
                [self createNotificationIOS10WithBody:alertBody];
        }
    }];
}
@end
