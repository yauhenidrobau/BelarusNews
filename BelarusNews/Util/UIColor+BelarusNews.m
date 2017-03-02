//
//  UIColor+BelarusNews.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 2/22/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "UIColor+BelarusNews.h"
#import "Constants.h"
#import "Macros.h"

@implementation UIColor (BelarusNews)

+(UIColor*)bn_titleColor {
    return [UIColor blackColor];
}

+(UIColor*)bn_nightModeBackgroundColor {
    return [UIColor blackColor];
}

+(UIColor*)bn_settingsBackgroundColor {
    return [UIColor colorWithRed:239.0 / 255.0 green:239.0 / 255.0 blue:243.0 / 255.0 alpha:1.];
}

+(UIColor*)bn_backgroundColor {
    return [UIColor whiteColor];
}

+(UIColor*)bn_mainBackgroundColor {
    return [UIColor colorWithRed:239.0 / 255.0 green:239.0 / 255.0 blue:243.0 / 255.0 alpha:1.];
}

+(UIColor*)bn_mainNightBackgroundColor {
    return [UIColor blackColor];
}

+(UIColor*)bn_nightModeTitleColor {
    return [UIColor whiteColor];
}

+(UIColor*)bn_lightBlueColor {
    return [UIColor colorWithRed:0.0 / 255.0 green:255.0 / 255.0 blue:184.0/ 255.0 alpha:1];
}

#pragma mark - NavigationBar

+(UIColor*)bn_navBarColor {
    return [UIColor colorWithRed:246.0 / 255.0 green:207.0 / 255.0 blue:129.0 / 255.0 alpha:1.];
}

+(UIColor*)bn_navBarNightColor {
    return [UIColor blackColor];
}

+(UIColor*)bn_navBarTitleColor {
    return [UIColor blackColor];
}

+(UIColor*)bn_navBarNightTitleColor {
    return [UIColor colorWithRed:0.0 / 255.0 green:255.0 / 255.0 blue:184.0/ 255.0 alpha:1];
}

#pragma mark - News Cell

+(UIColor*)bn_newsCellColor {
    return RGBA(191,191,191, 0.6);
}

+(UIColor*)bn_newsCellNightColor {
    return [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0/ 255.0 alpha:0.2];
}

+(UIColor*)bn_newsCellDateColor {
    return RGB(255,255,255);
}

+(UIColor*)bn_favoriteSelectedColor {
    return RGBA(255, 255, 255, 1);
}

+(UIColor*)bn_favoriteSelectedNightColor {
    return RGBA(0, 255, 184, 1);
}
@end
