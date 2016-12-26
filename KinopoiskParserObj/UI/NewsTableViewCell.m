//
//  NewsTableViewCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "NewsTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageNewsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;

@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.textColor = [UIColor whiteColor];
//    self.userDefaults = [NSUserDefaults standardUserDefaults];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)saveFavoriteNews:(NewsEntity*)entity {
    
    self.favoriteButton.imageView.image = nil;
}

-(void)cellForNews:(NewsEntity *)entity {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    self.titleLabel.text = entity.titleFeed;
    self.descriptionLabel.text = entity.descriptionFeed;
    [formatter setDateFormat:@"d MMM"];
    
    if([[formatter stringFromDate:entity.pubDateFeed] isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
        [formatter setDateFormat:@"HH:mm"];
        self.pubDateLabel.text =[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Today at", nil),[formatter stringFromDate:entity.pubDateFeed]];
        
    } else {
        [formatter setDateFormat:@"d MMM HH:mm:ss"];
        self.pubDateLabel.text = [formatter stringFromDate:entity.pubDateFeed];

    }
    [self.imageNewsView sd_setImageWithURL:[NSURL URLWithString:entity.urlImage]
                 placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",entity.feedIdString]]];
}
@end
