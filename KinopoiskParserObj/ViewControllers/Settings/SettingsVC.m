//
//  SettingsVC.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsVC.h"

#import "SettingsOfflineCell.h"
#import "SettingsNotificationsCell.h"
#import "SettingsAutoupdateCell.h"
#import "SettingsNightModeCellTableViewCell.h"
#import "Utils.h"
#import "UserDefaultsManager.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "UIColor+BelarusNews.h"

#define SIGN_OUT_CELL_TYPE @"SignOutCell"
#define OFFLINE_CELL_TYPE @"OfflineCell"
#define NOTIFICATION_CELL_TYPE @"NotificationCell"
#define AUTOUPDATES_CELL_TYPE @"AutoupdatesCell"
#define NIGHTMODE_CELL_TYPE @"NightModeCell"


typedef enum {
    OFFLINE_CELL,
    NOTIFICATION_CELL,
    AUTOUPDATE_CELL,
    NIGHTMODE_CELL,
    SIGN_OUT_CELL
}TypeCells;

@interface SettingsVC () <SettingsCellDelegate>

@property (nonatomic, strong) NSArray *cellTitleList;
@property (nonatomic, strong) NSArray *cellTitleListID;
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *viewControllersList;
@property (nonatomic, strong) NSArray *sectionAboutLinkList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsVC

#pragma mark - Override Properties

-(NSArray *)cellTitleListID {
    if (!_cellTitleListID.count) {
        _cellTitleListID = @[@"OfflineCell",
                           @"NotificationCell",
                           @"AutoupdatesCell",
                           @"NightModeCell",
                           @"SignOutCell"];
    }
    return _cellTitleListID;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"Settings", nil)];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configNightMode];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitleListID.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellTitleListID[indexPath.row] forIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:OFFLINE_CELL_TYPE]) {
        SettingsOfflineCell *offlineCell = (SettingsOfflineCell *)cell;
        offlineCell.cellDelegate = self;
        [offlineCell configCell];
        return offlineCell;
    } else if ([cell.reuseIdentifier isEqualToString:NOTIFICATION_CELL_TYPE]) {
        SettingsNotificationsCell *notificationCell = (SettingsNotificationsCell *)cell;
        notificationCell.cellDelegate = self;
        [notificationCell configCell];
        return notificationCell;
    } else if ([cell.reuseIdentifier isEqualToString:AUTOUPDATES_CELL_TYPE]) {
        SettingsAutoupdateCell *autoupdateCell = (SettingsAutoupdateCell *)cell;
        autoupdateCell.cellDelegate = self;
        [autoupdateCell configCell];
        return autoupdateCell;
    } else if ([cell.reuseIdentifier isEqualToString:NIGHTMODE_CELL_TYPE]) {
        SettingsNightModeCellTableViewCell *nightModeCell = (SettingsNightModeCellTableViewCell *)cell;
        nightModeCell.cellDelegate = self;
        [nightModeCell configCell];
        return nightModeCell;
    }
    if ([cell.reuseIdentifier isEqualToString:SIGN_OUT_CELL_TYPE]) {
    }                                                                          
    return cell;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == SIGN_OUT_CELL) {
        [Utils exitFromApplication];
    }
}

#pragma mark - SettingsCellDelegate
-(void)settingsOfflineCell:(UITableViewCell*)cell didChangeValue:(UISwitch*)sender {
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:OFFLINE_MODE];
}

-(void)settingsNotificationsCell:(UITableViewCell *)cell didChangeValue:(UISwitch *)sender{
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:NOTIFICATIONS_MODE];
}

-(void)settingsAutoupdateCell:(UITableViewCell *)cell didChangeValue:(UISwitch *)sender {
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:AUTOUPDATE_MODE];
}

-(void)settingsNightModeCell:(UITableViewCell *)cell didChangeValue:(UISwitch *)sender {
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:NIGHT_MODE];
    [self configNightMode];

}
#pragma mark Private

-(void)configNightMode {
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        self.tableView.backgroundColor = [UIColor bn_nightModeBackgroundColor];
    } else {
        self.tableView.backgroundColor = [UIColor bn_settingsBackgroundColor];
    }
    [self.tableView setNeedsDisplay];
}

@end
