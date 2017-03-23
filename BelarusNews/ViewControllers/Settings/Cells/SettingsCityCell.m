//
//  SettingsCityCell.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 2/24/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsCityCell.h"

#import "SettingsManager.h"

@interface SettingsCityCell ()

@end

@implementation SettingsCityCell

-(void)updateCity {
    self.cityNameLabel.text = [SettingsManager sharedInstance].currentCity;
}

@end
