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

#pragma mark - LifeCycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self updateData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.detailsDescriptionTV setContentOffset:CGPointZero animated:NO];
    });
    [self updateForNightMode:NO];
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        [self updateForNightMode:YES];
    }
}

#pragma mark - Private

-(void)updateData {
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.entity.urlImage]
                                             placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.entity.feedIdString]]];
    _detailsTitleLabel.text = self.entity.titleFeed;
        NSString *linkString = [NSString stringWithFormat:@"%@ : %@ \n\n\n ",NSLocalizedString(@"Source link", nil),self.sourceLink];

    self.detailsDescriptionTV.text = linkString;

    NSMutableAttributedString *text= [[NSMutableAttributedString alloc]initWithString:[self.detailsDescriptionTV.text stringByAppendingString:self.entity.descriptionFeed]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(text.length  - linkString.length, linkString.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(0, linkString.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(linkString.length,text.length - linkString.length)];
    self.detailsDescriptionTV.attributedText = text;
    [self.detailsDescriptionTV setContentSize:CGSizeMake(CGRectGetWidth(self.detailsDescriptionTV.frame), CGRectGetHeight(self.detailsDescriptionTV.frame))];
    self.detailsDescriptionTV.scrollEnabled = YES;

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
