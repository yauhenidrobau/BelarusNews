//
//  NotificationManager.m
//  KinopoiskParserObj
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

@implementation NotificationManager

SINGLETON(NotificationManager)

- (void)enableLocalNotificationsForLowerIOS {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge
                                            categories:nil];
    UIApplication *app = [UIApplication sharedApplication];
    
    if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [app registerUserNotificationSettings:settings];
    }
}

-(void)shouldCreateNotificalion:(CreateNotificationCallback)completion {
    NSArray *oldArray = [[RealmDataManager sharedInstance]getObjectsForEntity:[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentTitle"]];
    [[Utils getMainController] updateWithIndicator:NO];
    NSArray *newArray = [[RealmDataManager sharedInstance]getObjectsForEntity:[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentTitle"]];
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
    NSString *alertBody = body;
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.alertTitle = NSLocalizedString(@"Latest news",nil);
    localNotification.alertBody = alertBody;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;

    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];

}



@end
