//
//  SettingsNotificationsCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 06/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsNotificationsCell.h"

#import "SettingsManager.h"

@interface SettingsNotificationsCell ()

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@end

@implementation SettingsNotificationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.notificationSwitch setOn:[SettingsManager sharedInstance].isNotificationMode];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)NotificationsValueChanged:(UISwitch *)sender {
    [SettingsManager sharedInstance].isNotificationMode = sender.isOn;
    [self.cellDelegate settingsNotificationsCell:self didChangeValue:sender];
}

@end
