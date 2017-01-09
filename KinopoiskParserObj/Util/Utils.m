//
//  Utils.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 09/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "Utils.h"

#import "DateFormatterManager.h"

@implementation Utils

@end

@implementation NSDateFormatter (Localized)

+ (NSDateFormatter *)newLocalized
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[DateFormatterManager sharedInstance] currentLocale];
    return dateFormatter;
}

@end
