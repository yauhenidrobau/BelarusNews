//
//  UIColor+BelarusNews.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/22/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BelarusNews)

+(UIColor*)bn_titleColor;
+(UIColor*)bn_backgroundColor;
+(UIColor*)bn_lightBlueColor;

+(UIColor*)bn_settingsBackgroundColor;

+(UIColor*)bn_nightModeBackgroundColor;
+(UIColor*)bn_nightModeTitleColor;

+(UIColor*)bn_mainBackgroundColor;
+(UIColor*)bn_mainNightBackgroundColor;

//Navigation bar
+(UIColor*)bn_navBarColor;
+(UIColor*)bn_navBarNightColor;
+(UIColor*)bn_navBarTitleColor;
+(UIColor*)bn_navBarNightTitleColor;

//News Cell
+(UIColor*)bn_newsCellColor;
+(UIColor*)bn_newsCellDateColor;
+(UIColor*)bn_newsCellNightColor;
@end
