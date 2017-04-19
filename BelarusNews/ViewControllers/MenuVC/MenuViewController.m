//
//  MenuViewController.m
//  BelarusNews
//
//  Created by Admin on 02/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "MenuViewController.h"

#import "NewsTableView.h"
#import "UserDefaultsManager.h"
#import "SettingsManager.h"
#import "DataManager.h"
#import "CityObject.h"
#import "SWRevealViewController.h"
#import "CheckBoxView.h"
#import "Constants.h"
#import "Utils.h"

typedef enum NSInteger {
    MenuItemNews = 0,
    MenuItemFavorite = 1,
    MenuItemSettings = 2
} MenuItem;

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuImages;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *blurImage;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDegreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *weatherWind;
@property (strong, nonatomic) CityObject *cityObject;
@property (weak, nonatomic) IBOutlet UIImageView *weatherBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *noWeatherLabel;

@property (weak, nonatomic) IBOutlet CheckBoxView *CBView1;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView2;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView3;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView4;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView5;
@property (weak, nonatomic) IBOutlet UIView *checkBoxView;

@property (strong, nonatomic) NSArray *CBArray;
@end

@implementation MenuViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTitles = @[  NSLocalizedString(@"News",nil),
                        NSLocalizedString(@"Favorites",nil),
                        NSLocalizedString(@"Settings",nil)];
    self.CBArray = @[_CBView1,_CBView2,_CBView3,_CBView4,_CBView5];
    
    [Utils addShadowToView:self.checkBoxView];

    self.noWeatherLabel.text = NSLocalizedString(@"Set your city in settings to see the weather", nil);
    self.revealViewController.rearViewRevealWidth = CGRectGetWidth(self.view.frame) - 53.0f;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        self.blurImage.image = [UIImage imageNamed:@"menu_night_blur"];
    } else {
        self.blurImage.image = [UIImage imageNamed:@"menu_blur"];
    }
    self.cityObject = [SettingsManager sharedInstance].cityObject;
    if (self.cityObject.cityID) {
        self.noWeatherLabel.hidden = YES;
        self.cityNameLabel.text = [SettingsManager sharedInstance].currentCity;
        self.weatherDegreeLabel.text = [NSString stringWithFormat:@"%d°",self.cityObject.temperature - 273];
        self.weatherImage.image = [UIImage imageNamed:self.cityObject.mainWeatherIcon];
        self.weatherBackgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Image-%@",self.cityObject.mainWeatherIcon]];
        self.weatherBackgroundImage.hidden = NO;
        self.weatherWind.text = [NSString stringWithFormat:@"%@   %ld %@",NSLocalizedString(@"Wind", nil),(long)self.cityObject.windSpeed,NSLocalizedString(@"m/c", nil)];
        [self configWeatherDescription:self.cityObject.weatherID];
    } else {
        self.weatherBackgroundImage.hidden = YES;
        self.noWeatherLabel.hidden = NO;
    }
    
    [self prepareCategories];
    
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
    if (indexPath.row == MenuItemNews) {
        imageView.image = [UIImage imageNamed:@"left_menu_news"];
    } else if (indexPath.row == MenuItemFavorite) {
        imageView.image = [UIImage imageNamed:@"left_menu_favorite"];
    } else if (indexPath.row == MenuItemSettings) {
        imageView.image = [UIImage imageNamed:@"left_menu_settings"];
    }
    return cell;
}

#pragma mark - TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *rootVCId;
    NSString* storyboardName;
    switch (indexPath.row) {
        case MenuItemNews:
            storyboardName = @"News";
            rootVCId = @"BaseNavVC";
            break;
        case MenuItemFavorite:
            storyboardName = @"News";
            rootVCId = @"BaseNavVC";
            break;
        case MenuItemSettings:
            storyboardName = @"Settings";
            rootVCId = @"SettingsNavVC";
            break;
        default:
            [self closeMenu];
            return;
    }
    
    if (!storyboardName.length || !rootVCId.length) {
        [self closeMenu];
        return;
    }
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController* rootVC = [storyboard instantiateViewControllerWithIdentifier:rootVCId];
    if (indexPath.row == MenuItemFavorite) {
        [[NSUserDefaults standardUserDefaults]setObject:NSLocalizedString(@"Favorites",nil) forKey:@"Favorite"];
    } else {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Favorite"];
    }
    [self.revealViewController setFrontViewController:rootVC animated:YES];
    
    [self closeMenu];
}

#pragma mark - Private 

-(void)prepareCategories {
    NSArray *categories = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:CATEGORIES_KEY]]];
    for (NSInteger i = 0; i < self.CBArray.count; i++) {
        CheckBoxView *cbView = self.CBArray[i];
        cbView.titleString = categories[i][@"SourceName"];
        NSNumber *checked = categories[i][@"Checked"];
        
        cbView.checked = checked.integerValue;
    }
}

-(void)closeMenu {
    [self.revealViewController rightRevealToggleAnimated:YES];
}

-(void)configWeatherDescription:(NSInteger)weatherID {
    if (weatherID > 199 && weatherID < 233) {
        self.weatherDescription.text = NSLocalizedString(@"Thunderstorm",nil);
    } else  if (weatherID > 299 && weatherID < 322) {
        self.weatherDescription.text = NSLocalizedString(@"Drizzle rain",nil);
    } else  if (weatherID > 499 && weatherID < 532) {
        self.weatherDescription.text = NSLocalizedString(@"Shower rain",nil);
    } else  if (weatherID > 599 && weatherID < 623) {
        self.weatherDescription.text = NSLocalizedString(@"Snow",nil);
    } else  if (weatherID > 700 && weatherID < 782) {
        self.weatherDescription.text = NSLocalizedString(self.cityObject.mainWeatherDescription, nil);
    } else  if (weatherID == 800) {
        self.weatherDescription.text = NSLocalizedString(@"Clear", nil);
    } else  if (weatherID > 800 && weatherID < 805) {
        self.weatherDescription.text = NSLocalizedString(self.cityObject.mainWeatherDescription, nil);
    } else {
        self.weatherDescription.text = NSLocalizedString(self.cityObject.mainWeatherDescription, nil);
    }
}
@end
