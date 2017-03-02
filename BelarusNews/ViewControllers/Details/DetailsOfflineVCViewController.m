//
//  DetailsOfflineVCViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DetailsOfflineVCViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"
#import "Utils.h"

@interface DetailsOfflineVCViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailsDescriptionTV;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@end

@implementation DetailsOfflineVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self updateData];
    self.detailsDescriptionTV.userInteractionEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateForNightMode:NO];
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        [self updateForNightMode:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateData {
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.entity.urlImage]
                                             placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.entity.feedIdString]]];
    _detailsTitleLabel.text = self.entity.titleFeed;
    
    self.detailsDescriptionTV.text = self.entity.descriptionFeed;
    self.detailsDescriptionTV.font = [UIFont systemFontOfSize:17.0];
}

-(void)updateForNightMode:(BOOL)update {
    if (update) {
        [Utils setNightNavigationBar:self.navigationController.navigationBar];
        [Utils setNavigationBar:self.navigationController.navigationBar light:YES];
        self.view.backgroundColor = [UIColor bn_nightModeBackgroundColor];
        self.detailsDescriptionTV.textColor = [UIColor bn_backgroundColor];
    } else {
        [Utils setDefaultNavigationBar:self.navigationController.navigationBar];
        [Utils setNavigationBar:self.navigationController.navigationBar light:NO];

        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.view.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:239.0 / 255.0 blue:243.0 / 255.0 alpha:1.];
        self.detailsDescriptionTV.textColor = [UIColor bn_titleColor];
    }
}
@end
