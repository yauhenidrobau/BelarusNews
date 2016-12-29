//
//  SettingsVC.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsVC.h"

#import "SettingsOfflineCell.h"

#define SIGN_OUT_CELL_TYPE @"SignOutCell"
#define OFFLINE_CELL_TYPE @"OfflineCell"
#define SOUND_CELL_TYPE @"SoundCell"


typedef enum {
    SettingsAccountSection = 0,
    SettingsAboutSection = 1,
    SetingsNotificationsSection = 2,
}SettingsSection;

typedef enum {
    SettingsChangeAccountCell = 0,
    SettingsChangePasswordCell = 1,
    SettingsDeleteHistoryCell = 2,
    SettingsSignOutCell = 3,
    SettingsPrivacyPolicyCell = 0,
    SettingsCondotionsCell = 1,
    SettingsContactCell = 2,
    SettingsPushNotificationsCell = 0,
    SettingsEmailCell = 1,
    SettingsSMSCell = 2,
    SettingsFrequencyCell = 3,
}SettingsCell;

@interface SettingsVC () <SettingsCellDelegate>

@property (nonatomic, strong) NSArray *cellTitleList;
@property (nonatomic, strong) NSArray *cellTitleListID;
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *viewControllersList;
@property (nonatomic, strong) NSArray *sectionAboutLinkList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsVC

-(NSArray *)cellTitleListID {
    if (!_cellTitleListID.count) {
        _cellTitleListID = @[@"SignOutCell",
                           @"OfflineCell",
                           @"SoundCell"
                           ];
    }
    return _cellTitleListID;
}

-(NSArray *)cellTitleList {
    if (!_cellTitleList.count) {
        _cellTitleList = @[@"SVC_SIGN_OUT",
                           @"SVC_OffLine",
                           @"SVC_SOUND"
//                             @"SVC_PUSH_NOTIFICATIONS",
                             ];
    }
    return _cellTitleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"Settings", nil)];
    [self.navigationController.navigationBar setHidden:NO];
//    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kTitleHeaderFooterView];
//    self.tableView.backgroundColor = D_COLOR_WHITE;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setTintColor:D_COLOR_LIGHT_RED];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellTitleListID[indexPath.row] forIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:OFFLINE_CELL_TYPE]) {
        SettingsOfflineCell *offlineCell = (SettingsOfflineCell *)cell;
        offlineCell.cellDelegate = self;
    } else if ([cell.reuseIdentifier isEqualToString:SOUND_CELL_TYPE]) {
        UISwitch *soundSwitch = (UISwitch *)[cell viewWithTag:152];
    } 
    if ([cell.reuseIdentifier isEqualToString:SIGN_OUT_CELL_TYPE]) {
    }
    return cell;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([self.cellTitleList[indexPath.section][indexPath.row] isEqualToString:@"Sign Out"]) {
//        [[AccountHelper sharedAccountHelper] logOut];
//        [[NavigationHelper sharedNavigationHelper] openAuthScreen];
//    } else {
//        Class newClass = NSClassFromString(self.viewControllersList[indexPath.section][indexPath.row]);
//        id myObject = [newClass newInstance];
//        if ([myObject isKindOfClass:[XWebViewVC class]]) {
//            [myObject setUrlLink:[NSURL URLWithString:self.sectionAboutLinkList[indexPath.row]]];
//        }
//        [self.navigationController pushViewController:myObject animated:YES];
//    }
}

#pragma mark - SettingsCellDelegate
- (void)settingsOfflineCell:(UITableViewCell*)cell didChangeValue:(UISwitch*)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn forKey:@"OfflineMode"];
}

#pragma mark Private



@end
