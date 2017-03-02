//
//  SettingsNightModeCellTableViewCell.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 2/22/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsNightModeCellTableViewCell.h"
#import "SettingsManager.h"

@interface SettingsNightModeCellTableViewCell ()

@end

@implementation SettingsNightModeCellTableViewCell

-(BOOL)isModeEnabled {
    return [SettingsManager sharedInstance].isNightModeEnabled;
}

@end
