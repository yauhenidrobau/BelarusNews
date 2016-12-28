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
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)favoriteButtonDidTap:(id)sender {
    [self.cellDelegate newsTableViewCell:self didTapFavoriteButton:sender];    
}

-(void)cellForNews:(NewsEntity *)entity WithIndexPath:(NSIndexPath *)indexPath  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    self.titleLabel.text = entity.titleFeed;
    self.descriptionLabel.text = entity.descriptionFeed;
    [self.favoriteButton setImage:[self.favoriteButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    if (!entity.favorite) {
        [self.favoriteButton setTintColor:[UIColor grayColor]];
    } else {
        [self.favoriteButton setTintColor:[UIColor yellowColor]];
    }
    
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
