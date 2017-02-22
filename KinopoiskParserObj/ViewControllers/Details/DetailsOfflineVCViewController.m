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

@interface DetailsOfflineVCViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailsDescriptionTV;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@end

@implementation DetailsOfflineVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        self.detailsDescriptionTV.backgroundColor = [UIColor bn_nightModeBackgroundColor];
        self.detailsDescriptionTV.textColor = [UIColor bn_backgroundColor];
    } else {
        self.detailsDescriptionTV.backgroundColor = [UIColor bn_nightModeTitleColor];
        self.detailsDescriptionTV.textColor = [UIColor bn_titleColor];
    }
}
@end
