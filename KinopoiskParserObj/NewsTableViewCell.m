//
//  NewsTableViewCell.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

#warning зачем @synthesize ?

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize imageNewsView;


#warning не ленись ставить пробелы и новые строки, пожалей тех, кто будет читать твой код после тебя
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
