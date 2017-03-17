//
//  AppDelegate.m
//  BelarusNews
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
#import "UserDefaultsManager.h"
#import "Constants.h"
#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"
#import "DataManager.h"
#import <Google/Analytics.h>

@import GooglePlaces;

@interface AppDelegate ()

@end

@implementation AppDelegate

NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     Fabric
     */
    [Fabric with:@[[Crashlytics class]]];

    /*
     Google Autocomletor
     */
    [GMSPlacesClient provideAPIKey:GOOGLE_PLACES_KEY];
    
    /*
     Google Analytics
     */
    [self enableGoogleAnalytics];
    
    /*
     Weather
     */
    [[DataManager sharedInstance] updateWeatherForecastWithCallback:^(CityObject *cityObject, NSError *error) {
    }];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
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
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIUserId
           value:@"80107844"];

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"            // Event category (required)
                                                      action:@"User Sign In"  // Event action (required)
                                                       label:nil              // Event label
                                                       value:nil] build]];    // Event value
    tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-80107844-2"];
    [GAI sharedInstance].defaultTracker = tracker;
    tracker.allowIDFACollection = YES;
}
@end
