//
//  SettingsManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/16/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic) BOOL isNotificationMode;
@property (nonatomic) BOOL isOfflineMode;

+(instancetype)sharedInstance;

@end
