//
//  SettingsOfflineCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsOfflineCell.h"
#import "SettingsManager.h"

@interface SettingsOfflineCell ()

@end

@implementation SettingsOfflineCell

#pragma mark - Override properties

-(BOOL)isModeEnabled {
    return [SettingsManager sharedInstance].isOfflineMode;
}

@end
