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

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuImages;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTitles = @[NSLocalizedString(@"Profile",nil),
                        NSLocalizedString(@"Favorites",nil),
                        NSLocalizedString(@"Settings",nil),
                        NSLocalizedString(@"About",nil),
                        NSLocalizedString(@"Log out",nil)];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 50.0;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 3.0f;
    self.avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.avatarImageView.layer.shouldRasterize = YES;
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
    titleLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NewsTableView *vc = [[NewsTableView alloc]init];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    vc.urlIdentificator = self.menuTitles[indexPath.row];
//    RootViewController *rootVC = [[RootViewController alloc]init];
//    [rootVC.mainNavigationController setViewControllers:@[vc] animated:YES];
    self.title = self.menuTitles[indexPath.row];
    [self.sideBarController hideMenuViewController:YES];
//    [self.sideBarController showViewController:vc sender:self];

}


@end
