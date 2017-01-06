//
//  SettingsNotificationsCell.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 06/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsCellDelegate.h"

@interface SettingsNotificationsCell : UITableViewCell

@property (nonatomic, weak) id<SettingsCellDelegate>cellDelegate;
@end
