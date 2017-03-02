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
        self.isOfflineMode = [[UserDefaultsManager sharedInstance]boolForKey:OFFLINE_MODE];
        self.isNotificationMode = [[UserDefaultsManager sharedInstance]boolForKey:NOTIFICATIONS_MODE];
        self.isAutoupdateEnabled = [[UserDefaultsManager sharedInstance]boolForKey:AUTOUPDATE_MODE];
        self.isNightModeEnabled = [[UserDefaultsManager sharedInstance]boolForKey:NIGHT_MODE];
        self.isRoundImagesEnabled = [[UserDefaultsManager sharedInstance]boolForKey:NIGHT_MODE];
        self.currentCity = [[UserDefaultsManager sharedInstance]objectForKey:CURRENT_CITY];
        NSData *cityData = [[UserDefaultsManager sharedInstance]objectForKey:CITY_FORECAST];
        if (cityData) {
            self.cityObject = [NSKeyedUnarchiver unarchiveObjectWithData:cityData];
        } else {
            self.cityObject = [CityObject new];
        }
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

-(void)setIsAutoupdateEnabled:(BOOL)isAutoupdateEnabled {
    _isAutoupdateEnabled = isAutoupdateEnabled;
}

-(void)setIsNightModeEnabled:(BOOL)isNightModeEnabled {
    _isNightModeEnabled = isNightModeEnabled;
}

-(void)setIsRoundImagesEnabled:(BOOL)isRoundImagesEnabled {
    _isRoundImagesEnabled = isRoundImagesEnabled;
}

-(void)setCurrentCity:(NSString *)currentCity {
    _currentCity = currentCity;
}

-(void)setCityObject:(CityObject *)cityObject {
    _cityObject = cityObject;
}
@end
