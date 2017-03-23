//
//  SettingsRoundImagesCell.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 2/24/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "SettingsRoundImagesCell.h"
#import "SettingsManager.h"
#import "UserDefaultsManager.h"
#import "Constants.h"
#import "UIColor+BelarusNews.h"

@interface SettingsRoundImagesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *roundedImages;

@end

@implementation SettingsRoundImagesCell

#pragma mark - LifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.roundedImages.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    [self.roundedImages addGestureRecognizer:tapGesture];
    [self setImageColor];
}

#pragma mark Override Properties

-(BOOL)isModeEnabled {
    return [SettingsManager sharedInstance].isRoundImagesEnabled;
}

#pragma mark - Private

-(void)configRoundImageCell {
    if ([SettingsManager sharedInstance].isRoundImagesEnabled) {
        self.roundedImages.image = [UIImage imageNamed:@"checkmark"];
    } else {
        self.roundedImages.image = [UIImage imageNamed:@"unCheck"];
    }
    [self setImageColor];
}

#pragma mark - UIGesture Actions

-(void)imageAction:(UITapGestureRecognizer*)recognizer {
    if ([SettingsManager sharedInstance].isRoundImagesEnabled) {
        [SettingsManager sharedInstance].isRoundImagesEnabled = NO;
        self.roundedImages.image = [UIImage imageNamed:@"unCheck"];
        [[UserDefaultsManager sharedInstance]setBool:NO ForKey:ROUND_IMAGES];
    } else {
        [SettingsManager sharedInstance].isRoundImagesEnabled = YES;
        self.roundedImages.image = [UIImage imageNamed:@"checkmark"];
        [[UserDefaultsManager sharedInstance]setBool:YES ForKey:ROUND_IMAGES];
    }
    [self setImageColor];
}

-(void)setImageColor {
    self.roundedImages.image = [self.roundedImages.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    if ([SettingsManager sharedInstance].isRoundImagesEnabled) {
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        [self.roundedImages setTintColor:[UIColor bn_mainNightColor]];
    } else {
    [self.roundedImages setTintColor:[UIColor bn_mainColor]];
    }
//    } else {
//        [self.roundedImages setTintColor:[UIColor lightGrayColor]];
//    }
}
@end
