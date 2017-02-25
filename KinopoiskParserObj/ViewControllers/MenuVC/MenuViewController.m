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
#import "DataManager.h"
#import "CityObject.h"

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
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDegreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *weatherWind;
@property (strong, nonatomic) CityObject *cityObject;
@property (weak, nonatomic) IBOutlet UIImageView *weatherBackgroundImage;
@end

@implementation MenuViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTitles = @[
                        NSLocalizedString(@"Favorites",nil),
                        NSLocalizedString(@"Settings",nil)];
    self.logoutButton.layer.cornerRadius = 15;
    self.logoutButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoutButton.layer.borderWidth = 2.0f;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        self.blurImage.image = [UIImage imageNamed:@"black_blur"];
    } else {
        self.blurImage.image = [UIImage imageNamed:@"black_blur"];
//        self.blurImage.image = [UIImage imageNamed:@"left_menu_Orange_Blur"];
    }
    self.cityObject = [SettingsManager sharedInstance].cityObject;
    if (self.cityObject.cityID) {
        self.cityNameLabel.text = [SettingsManager sharedInstance].currentCity;
        self.weatherDegreeLabel.text = [NSString stringWithFormat:@"%ld°",self.cityObject.temperature - 273];
        self.weatherImage.image = [UIImage imageNamed:self.cityObject.mainWeatherIcon];
        self.weatherBackgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Image-%@",self.cityObject.mainWeatherIcon]];

        self.weatherWind.text = [NSString stringWithFormat:@"%@   %d m/c",NSLocalizedString(@"Wind", nil),self.cityObject.windSpeed];
        self.weatherDescription.text = NSLocalizedString(self.cityObject.mainWeatherDescription,nil);
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

#pragma mark IBActions

- (IBAction)logoutTouchUpInside:(id)sender {
    self.titleString = NSLocalizedString(@"Log out",nil);
    [self.sideBarController hideMenuViewController:YES];
}
@end
