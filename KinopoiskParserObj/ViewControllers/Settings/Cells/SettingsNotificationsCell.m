//
//  SettingsNotificationsCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 06/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsNotificationsCell.h"

#define NOTIFICATIONS_MODE @"NotificationsMode"

@interface SettingsNotificationsCell ()

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;


@end

@implementation SettingsNotificationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.notificationSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:NOTIFICATIONS_MODE]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)NotificationsValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.isOn forKey:NOTIFICATIONS_MODE];
    [self.cellDelegate settingsNotificationsCell:self didChangeValue:sender];
}

@end
