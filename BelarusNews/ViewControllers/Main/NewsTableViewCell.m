//
//  NewsTableViewCell.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "NewsTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "DateFormatterManager.h"
#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"
#import "Constants.h"

@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageNewsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end

@implementation NewsTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.imageNewsView.clipsToBounds = YES;
    self.imageNewsView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - IBActions
- (IBAction)favoriteButtonDidTap:(id)sender {
    [self.cellDelegate newsTableViewCell:self didTapFavoriteButton:sender];    
}

- (IBAction)shareButtonDidTap:(id)sender {
    [self.cellDelegate newsTableViewCell:self didTapShareButton:sender];
}

#pragma mark - Private
-(void)updateNightModeCell:(BOOL)update {
    if (update) {
        self.titleLabel.textColor = [UIColor bn_nightModeTitleColor];
        self.cellBackgroundView.backgroundColor = [UIColor bn_newsCellNightColor];
        self.shareButton.tintColor = [UIColor bn_nightModeTitleColor];
        if (self.favoriteButton.tintColor == [UIColor blackColor]) {
            self.favoriteButton.tintColor = [UIColor bn_backgroundColor];
        } else {
            self.favoriteButton.tintColor = [UIColor bn_lightBlueColor];
        }
        self.pubDateLabel.textColor = [UIColor bn_favoriteSelectedNightColor];
    } else {
        self.titleLabel.textColor = [UIColor bn_titleColor];
        self.cellBackgroundView.backgroundColor = [UIColor bn_newsCellColor];
        self.shareButton.tintColor = [UIColor bn_titleColor];
        if (self.favoriteButton.tintColor == [UIColor blackColor]) {
        } else {
            self.favoriteButton.tintColor = [UIColor bn_favoriteSelectedColor];
        }
        self.pubDateLabel.textColor = [UIColor bn_newsCellDateColor];
    }
}

-(void)cellForNews:(NewsEntity *)entity WithIndexPath:(NSIndexPath *)indexPath  {
    [self layoutIfNeeded];
    
    self.sourceLabel.text = entity.sourceName;
    self.titleLabel.text = entity.titleFeed;
    self.descriptionLabel.text = entity.descriptionFeed;
    [self.favoriteButton setImage:[self.favoriteButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.shareButton setImage:[self.shareButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.shareButton setTintColor:[UIColor blackColor]];

    if (!entity.favorite) {
        [self.favoriteButton setTintColor:[UIColor blackColor]];
    } else {
        [self.favoriteButton setTintColor:[UIColor bn_lightBlueColor]];
    }
    
    if([[[DateFormatterManager sharedInstance] stringFromDate:entity.pubDateFeed withFormat:@"d MMM"] isEqualToString:[[DateFormatterManager sharedInstance] stringFromDate:[NSDate date] withFormat:@"d MMM"]]) {
        self.pubDateLabel.text =[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Today at", nil),[[DateFormatterManager sharedInstance] stringFromDate:entity.pubDateFeed withFormat:@"HH:mm"]];
        
    } else {
        self.pubDateLabel.text = [[DateFormatterManager sharedInstance] stringFromDate:entity.pubDateFeed withFormat:@"d MMM HH:mm:ss"];

    }
    [self.imageNewsView sd_setImageWithURL:[NSURL URLWithString:entity.urlImage]
                 placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",entity.category]]];
    self.imageNewsView.layer.cornerRadius = 0;
    if ([SettingsManager sharedInstance].isRoundImagesEnabled) {
        self.imageNewsView.layer.cornerRadius = CGRectGetWidth(self.imageNewsView.frame) / 2;
    }
    [self updateFontSize];
}

-(UIImageView*)imageFromCell {
    return self.imageNewsView;
}

-(void)updateFontSize {
    float fontSize = 14;
    if (IS_IPHONE_4_OR_LESS) {
        float fontSize = 12;

        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.pubDateLabel.font = [UIFont systemFontOfSize:fontSize-1];
    } else  if (IS_IPHONE_5) {
        float fontSize = 13;
        
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.pubDateLabel.font = [UIFont systemFontOfSize:fontSize-1];
    } else if (IS_IPHONE_6 || IS_IPHONE_6P){
        float fontSize = 15;
        
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.pubDateLabel.font = [UIFont systemFontOfSize:fontSize-2];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.pubDateLabel.font = [UIFont systemFontOfSize:fontSize-2];
    }
}
@end
