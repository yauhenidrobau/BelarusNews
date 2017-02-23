//
//  MenuViewController.m
//  KinopoiskParserObj
//
//  Created by Admin on 02/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "MenuViewController.h"

#import "NewsTableView.h"
#import "RootViewController.h"
#import "UserDefaultsManager.h"
#import "SettingsManager.h"

typedef enum {
    CellTypeFavorite,
    CellTypeSettings
}CellTypes;

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuImages;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *blurImage;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTitles = @[
//                        NSLocalizedString(@"Profile",nil),
                        NSLocalizedString(@"Favorites",nil),
                        NSLocalizedString(@"Settings",nil)];
//                        NSLocalizedString(@"About",nil),
//                        NSLocalizedString(@"Log out",nil)];
    self.logoutButton.layer.cornerRadius = 15;
    self.logoutButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoutButton.layer.borderWidth = 2.0f;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        self.blurImage.image = [UIImage imageNamed:@"black_blur"];
    } else {
        self.blurImage.image = [UIImage imageNamed:@"left_menu_Orange_Blur"];
    }
    
}
#pragma mark - TABLE VIEW DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
    titleLabel.text = self.menuTitles[indexPath.row];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:3];
    if (indexPath.row == CellTypeFavorite) {
        imageView.image = [UIImage imageNamed:@"left_menu_favorite"];
    } else if (indexPath.row == CellTypeSettings) {
        imageView.image = [UIImage imageNamed:@"left_menu_settings"];
    }
    return cell;
}

#pragma mark - TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.titleString = self.menuTitles[indexPath.row];
    [self.sideBarController hideMenuViewController:YES];
//    [self.sideBarController showViewController:vc sender:self];

}

- (IBAction)logoutTouchUpInside:(id)sender {
    self.titleString = NSLocalizedString(@"Log out",nil);
    [self.sideBarController hideMenuViewController:YES];
}

@end
