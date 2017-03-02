//
//  NewsTableViewCell.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEntity.h"

@class NewsTableViewCell;

@protocol NewsTableViewCellDelegate <NSObject>

- (void)newsTableViewCell:(NewsTableViewCell*)cell didTapFavoriteButton:(UIButton*)button;
- (void)newsTableViewCell:(NewsTableViewCell*)cell didTapShareButton:(UIButton*)button;

@end

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NewsTableViewCellDelegate> cellDelegate;

-(void)cellForNews:(NewsEntity *)entity WithIndexPath:(NSIndexPath *)indexPath;
-(void)updateNightModeCell:(BOOL)update;
-(UIImageView*)imageFromCell;

@end
