//
//  NewsTableViewCell.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEntity.h"

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

-(void)cellForNews:(NewsEntity *)entity;
-(void)saveFavoriteNews:(NewsEntity*)entity;

@end
