//
//  SettingsManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/16/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsManager.h"

#import "Macros.h"
#import "Constants.h"
#import "UserDefaultsManager.h"

@implementation SettingsManager

SINGLETON(SettingsManager)

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.isOfflineMode = [[UserDefaultsManager sharedInstance]getBoolForKey:OFFLINE_MODE];
        self.isNotificationMode = [[UserDefaultsManager sharedInstance]getBoolForKey:NOTIFICATIONS_MODE];
    }
    return self;
}

#pragma mark - Override properties

-(void)setIsOfflineMode:(BOOL)isOfflineMode {
    _isOfflineMode = isOfflineMode;
}

-(void)setIsNotificationMode:(BOOL)isNotificationMode {
    _isNotificationMode = isNotificationMode;
}

@end
