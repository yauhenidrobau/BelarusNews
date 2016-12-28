//
//  SettingsOfflineCell.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsCellDelegate.h"

@interface SettingsOfflineCell : UITableViewCell

@property (nonatomic, weak) id<SettingsCellDelegate> cellDelegate;

@end
