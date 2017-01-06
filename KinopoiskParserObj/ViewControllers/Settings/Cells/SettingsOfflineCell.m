//
//  SettingsOfflineCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsOfflineCell.h"

#define OFFLINE_MODE @"OfflineMode"

@interface SettingsOfflineCell ()
@property (weak, nonatomic) IBOutlet UISwitch *offlineSwitch;

@end

@implementation SettingsOfflineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.offlineSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:OFFLINE_MODE]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)OfflineModeValueChanged:(id)sender {
    [self.cellDelegate settingsOfflineCell:self didChangeValue:sender];
}

@end
