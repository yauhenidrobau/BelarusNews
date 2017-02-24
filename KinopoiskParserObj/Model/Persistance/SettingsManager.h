//
//  SettingsManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/16/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityObject.h"

@interface SettingsManager : NSObject

@property (nonatomic) BOOL isNotificationMode;
@property (nonatomic) BOOL isOfflineMode;
@property (nonatomic) BOOL isAutoupdateEnabled;
@property (nonatomic) BOOL isNightModeEnabled;
@property (nonatomic) BOOL isRoundImagesEnabled;
@property (nonatomic) CityObject *currentCity;

+(instancetype)sharedInstance;

@end
