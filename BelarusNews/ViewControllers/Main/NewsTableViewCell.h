//
//  NewsTableViewCell.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEntity.h"

#import <SESlideTableViewCell.h>

@class NewsTableViewCell;

@protocol NewsTableViewCellDelegate <NSObject>

- (void)newsTableViewCell:(NewsTableViewCell*)cell didTapFavoriteButton:(UIButton*)button;
- (void)newsTableViewCell:(NewsTableViewCell*)cell didTapShareButton:(UIButton*)button;

@end

@interface NewsTableViewCell : SESlideTableViewCell

@property (nonatomic, weak) id<NewsTableViewCellDelegate> cellDelegate;
@property (nonatomic,readonly) CGRect shareViewFrame;
@property (nonatomic) BOOL isUpdatedCell;
@property (nonatomic,readonly) UIColor *mainBackgroundColor;

-(void)cellForNews:(NewsEntity *)entity WithIndexPath:(NSIndexPath *)indexPath;
-(void)updateNightModeCell:(BOOL)update;
-(UIImageView*)imageFromCell;
-(void)updateCellWithRightSwipe;
-(void)updateCellWithLeftSwipe;
-(void)setDefaultCellStyle;

- (void)favoriteButtonDidTap:(id)sender;
- (void)shareButtonDidTap:(id)sender;

@end
