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
#import "SettingsRoundImagesCell.h"
#import "SettingsCityCell.h"

#import "LocationAutoCompleteController.h"

#import "Utils.h"
#import "UserDefaultsManager.h"
#import "DataManager.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "UIColor+BelarusNews.h"

#define OFFLINE_CELL_TYPE @"OfflineCell"
#define NOTIFICATION_CELL_TYPE @"NotificationCell"
#define AUTOUPDATES_CELL_TYPE @"AutoupdatesCell"
#define NIGHTMODE_CELL_TYPE @"NightModeCell"
#define ROUND_IMAGES_CELL_TYPE @"RoundImagesCell"
#define CITY_CELL_TYPE @"CityCell"


typedef enum {
    OFFLINE_CELL,
    NOTIFICATION_CELL,
    AUTOUPDATE_CELL,
    NIGHTMODE_CELL,
    ROUND_IMAGES_CELL,
    CITY_CELL
}TypeCells;

@interface SettingsVC () <SettingsCellDelegate>

@property (nonatomic, strong) NSArray *cellTitleList;
@property (nonatomic, strong) NSArray *cellTitleListID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LocationAutoCompleteController *locationController;
@property (nonatomic, strong) NSString *cityString;

@end

@implementation SettingsVC

#pragma mark - Override Properties

-(NSArray *)cellTitleListID {
    if (!_cellTitleListID.count) {
        _cellTitleListID = @[@"OfflineCell",
                           @"NotificationCell",
                           @"AutoupdatesCell",
                           @"NightModeCell",
                           @"RoundImagesCell",
                           @"CityCell"];
    }
    return _cellTitleListID;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareLocationController];
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
    } else if ([cell.reuseIdentifier isEqualToString:ROUND_IMAGES_CELL_TYPE]) {
        SettingsRoundImagesCell *roundImagesCell = (SettingsRoundImagesCell *)cell;
        roundImagesCell.cellDelegate = self;
        [roundImagesCell configRoundImageCell];
        [roundImagesCell configCell];
        return roundImagesCell;
    } else if ([cell.reuseIdentifier isEqualToString:CITY_CELL_TYPE]) {
        SettingsCityCell *cityCell = (SettingsCityCell *)cell;
        cityCell.cellDelegate = self;
        [cityCell configCell];
        [cityCell updateCity];
        return cityCell;
    }
    return cell;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SettingsCellDelegate
-(void)settingsOfflineCell:(UITableViewCell*)cell didChangeValue:(UISwitch*)sender {
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:OFFLINE_MODE];
    [SettingsManager sharedInstance].isOfflineMode = sender.isOn;
}

-(void)settingsNotificationsCell:(UITableViewCell *)cell didChangeValue:(UISwitch *)sender{
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:NOTIFICATIONS_MODE];
    [SettingsManager sharedInstance].isNotificationMode = sender.isOn;
}

-(void)settingsAutoupdateCell:(UITableViewCell *)cell didChangeValue:(UISwitch *)sender {
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:AUTOUPDATE_MODE];
    [SettingsManager sharedInstance].isAutoupdateEnabled = sender.isOn;
}

-(void)settingsNightModeCell:(UITableViewCell *)cell didChangeValue:(UISwitch *)sender {
    [[UserDefaultsManager sharedInstance]setBool:sender.isOn ForKey:NIGHT_MODE];
    [SettingsManager sharedInstance].isNightModeEnabled = sender.isOn;
    [self viewWillAppear:YES];
}

#pragma mark - Location

- (void)prepareLocationController {
    self.locationController = [LocationAutoCompleteController new];
    
    typeof(self) __weak welf = self;
    self.locationController.didSelectPlace = ^(GMSPlace *place) {
        welf.cityString = place.name;
        for (GMSAddressComponent *component in place.addressComponents) {
            if ([component.type isEqualToString:@"locality"]) {
                 welf.cityString = component.name;
                [[UserDefaultsManager sharedInstance] setObject:component.name forKey:CURRENT_CITY];
                [SettingsManager sharedInstance].currentCity = component.name;
                [[DataManager sharedInstance] updateWeatherForecastWithCallback:^(CityObject *cityObject, NSError *error) {
                    [welf.tableView reloadData];
                }];
                break;
            }
        }
    };
}

- (IBAction)didTapChooseLocation:(id)sender {
    [self.locationController presentInController:self];
}


#pragma mark Private

-(void)configNightMode {
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        self.tableView.backgroundColor = [UIColor bn_nightModeBackgroundColor];
        [Utils setNightNavigationBar:self.navigationController.navigationBar];
        [Utils setNavigationBar:self.navigationController.navigationBar light:YES];
    } else {
        self.tableView.backgroundColor = [UIColor bn_settingsBackgroundColor];
        [Utils setDefaultNavigationBar:self.navigationController.navigationBar];
        [Utils setNavigationBar:self.navigationController.navigationBar light:NO];

    }
}

@end
