//
//  SettingsNotificationsCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 06/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsNotificationsCell.h"

#import "SettingsManager.h"
#import "UIColor+BelarusNews.h"

@interface SettingsNotificationsCell ()

@end

@implementation SettingsNotificationsCell

-(BOOL)isModeEnabled {
    return [SettingsManager sharedInstance].isNotificationMode;
}

@end
