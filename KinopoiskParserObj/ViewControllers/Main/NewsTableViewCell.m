//
//  NewsTableViewCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "NewsTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "DateFormatterManager.h"

@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageNewsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

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

- (IBAction)shareButtonDidTap:(id)sender {
    [self.cellDelegate newsTableViewCell:self didTapShareButton:sender];
}

-(void)cellForNews:(NewsEntity *)entity WithIndexPath:(NSIndexPath *)indexPath  {
    [self layoutIfNeeded];
    self.imageNewsView.layer.cornerRadius = 30;

    self.titleLabel.text = entity.titleFeed;
    self.descriptionLabel.text = entity.descriptionFeed;
    [self.favoriteButton setImage:[self.favoriteButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.shareButton setImage:[self.shareButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.shareButton setTintColor:[UIColor blackColor]];

    if (!entity.favorite) {
        [self.favoriteButton setTintColor:[UIColor blackColor]];
    } else {
        [self.favoriteButton setTintColor:[UIColor colorWithRed:81.0 / 255.0 green:255.0 /255.0  blue:181.0 /255.0 alpha:1]];
    }
    
    if([[[DateFormatterManager sharedInstance] stringFromDate:entity.pubDateFeed withFormat:@"d MMM"] isEqualToString:[[DateFormatterManager sharedInstance] stringFromDate:[NSDate date] withFormat:@"d MMM"]]) {
        self.pubDateLabel.text =[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Today at", nil),[[DateFormatterManager sharedInstance] stringFromDate:entity.pubDateFeed withFormat:@"HH:mm"]];
        
    } else {
        self.pubDateLabel.text = [[DateFormatterManager sharedInstance] stringFromDate:entity.pubDateFeed withFormat:@"d MMM HH:mm:ss"];

    }
    [self.imageNewsView sd_setImageWithURL:[NSURL URLWithString:entity.urlImage]
                 placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",entity.feedIdString]]];
}

-(UIImageView*)imageFromCell {
    return self.imageNewsView;
}
@end
