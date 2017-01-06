//
//  DetailsOfflineVCViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DetailsOfflineVCViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}

-(void)updateData {
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.entity.urlImage]
                                             placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.entity.feedIdString]]];
    _detailsTitleLabel.text = [self stringByStrippingHTML:self.entity.titleFeed];
    
    self.detailsDescriptionTV.text = [self stringByStrippingHTML:self.entity.descriptionFeed];
        self.detailsDescriptionTV.font = [UIFont systemFontOfSize:17.0];
}
@end
