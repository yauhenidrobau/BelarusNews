//
//  SettingsAutoupdateCell.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 2/17/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsAutoupdateCell.h"

#import "SettingsManager.h"

@interface SettingsAutoupdateCell ()

@end

@implementation SettingsAutoupdateCell

-(BOOL)isModeEnabled {
    return [SettingsManager sharedInstance].isAutoupdateEnabled;
}

@end
