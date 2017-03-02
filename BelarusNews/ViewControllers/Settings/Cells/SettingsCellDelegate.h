//
//  SettingsCellDelegate.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsCellDelegate <NSObject>

- (void)settingsOfflineCell:(UITableViewCell*)cell didChangeValue:(UISwitch*)sender;
- (void)settingsNotificationsCell:(UITableViewCell*)cell didChangeValue:(UISwitch*)sender;
- (void)settingsAutoupdateCell:(UITableViewCell*)cell didChangeValue:(UISwitch*)sender;
- (void)settingsNightModeCell:(UITableViewCell*)cell didChangeValue:(UISwitch*)sender;


@end
