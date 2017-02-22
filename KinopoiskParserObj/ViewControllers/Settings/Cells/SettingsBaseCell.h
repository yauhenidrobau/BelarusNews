//
//  SettingsBaseCell.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/22/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsCellDelegate.h"

@interface SettingsBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (nonatomic, readonly) BOOL isModeEnabled;

-(void)configCell;

@property (nonatomic, weak) id<SettingsCellDelegate> cellDelegate;

@end
