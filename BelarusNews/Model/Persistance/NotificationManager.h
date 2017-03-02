//
//  NotificationManager.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 13/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CreateNotificationCallback)(NSString *body,NSError *error);

@interface NotificationManager : NSObject

+(instancetype)sharedInstance;
-(void)registerForPushNotificationsWithApplication:(UIApplication *)application;
-(void)shouldCreateNotificalion:(CreateNotificationCallback)completion;
-(void)createNotificationIOSLower10WithBody:(NSString *)body;
-(void)createNotificationIOS10WithBody:(NSString *)body;
-(void)cancellAllNotifications;
-(void)startMonitoring;

@end
