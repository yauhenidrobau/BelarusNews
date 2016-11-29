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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)cellForNews:(NewsEntity *)entity AndTitles:(NSArray *)titlesArray AndIndex:(NSInteger)index {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"d MMM HH:mm:ss"];
    self.titleLabel.text = entity.titleFeed;
    self.descriptionLabel.text = entity.descriptionFeed;
    self.pubDateLabel.text =[formatter stringFromDate:entity.pubDateFeed];
    [self.imageNewsView sd_setImageWithURL:[NSURL URLWithString:entity.urlImage]
                 placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",titlesArray[index]]]];
    
//    [self downloadThumbnails:[NSURL URLWithString:entity.urlImage] AndTitles:(NSArray *)titlesArray AndIndex:(NSInteger)index];
    
    
//    self.imageNewsView.image =
//    cell.titleLabel.text = newsEntity.titleFeed;
//    cell.descriptionLabel.text = newsEntity.descriptionFeed;
//    if (newsEntity.urlImage) {
//#warning если картинки большие и долго загружаются, то таблица будет дергаться, потому что ты грузишь картинки в главном потоке.
//        cell.imageNewsView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newsEntity.urlImage]]];
//    } else {
//        cell.imageNewsView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]]];
//    }
}

- (void) downloadThumbnails:(NSURL *)imageUrl AndTitles:(NSArray *)titlesArray AndIndex:(NSInteger)index {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:imageUrl
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
         if (image) {
             self.imageNewsView.image = image;
         } else {
             self.imageNewsView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",titlesArray[index]]];
         }
     }];
    
}
@end
