//
//  SettingsBaseCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/22/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsBaseCell.h"

#import "Constants.h"
#import "UserDefaultsManager.h"
#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"

@interface SettingsBaseCell ()

@end

@implementation SettingsBaseCell

#pragma mark - LifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

#pragma mark - IBActions

- (IBAction)switchValueChanged:(UISwitch *)sender {
    switch (sender.tag) {
        case SettingsCellTypeOffline:
            [[UserDefaultsManager sharedInstance] setBool:sender.isOn ForKey:OFFLINE_MODE];
            [self.cellDelegate settingsOfflineCell:self didChangeValue:sender];
            break;
        case SettingsCellTypeNotification:
            [[UserDefaultsManager sharedInstance] setBool:sender.isOn ForKey:NOTIFICATIONS_MODE];
            [self.cellDelegate settingsNotificationsCell:self didChangeValue:sender];
            break;
        case SettingsCellTypeAutoupdate:
            [[UserDefaultsManager sharedInstance] setBool:sender.isOn ForKey:AUTOUPDATE_MODE];
            [self.cellDelegate settingsAutoupdateCell:self didChangeValue:sender];
            break;
        case SettingsCellTypeNightMode:
            [[UserDefaultsManager sharedInstance] setBool:sender.isOn ForKey:NIGHT_MODE];
            [self.cellDelegate settingsNightModeCell:self didChangeValue:sender];
            break;
        default:
            break;
    }
}

-(void)configCell {
    [self.cellSwitch setOn:self.isModeEnabled];
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        self.cellTitleLabel.textColor = [UIColor bn_nightModeTitleColor];
        self.separatorView.backgroundColor = [UIColor bn_lightBlueColor];
    } else {
        self.cellTitleLabel.textColor = [UIColor bn_titleColor];
        self.separatorView.backgroundColor = [UIColor lightGrayColor];
    }
}
@end
