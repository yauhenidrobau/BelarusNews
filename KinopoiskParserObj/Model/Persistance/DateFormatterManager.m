//
//  DateFormatterManager.m
//  KinopoiskParserObj
//
//  Created by Admin on 07/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DateFormatterManager.h"
#import "Macros.h"
#import "Utils.h"

@interface DateFormatterManager ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DateFormatterManager

SINGLETON(DateFormatterManager)

-(instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [NSDateFormatter new];
    }
    return self;
}

- (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat {
    if (!dateString.length) {
        return nil;
    }
    [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

    [self.dateFormatter setDateFormat:dateFormat];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)dateFormat {
    if (!date) {
        return nil;
    }
    [self.dateFormatter setLocale:[self currentLocale]];

    [self.dateFormatter setDateFormat:dateFormat];
    return [[self.dateFormatter stringFromDate:date]capitalizedString];
}

- (NSLocale *)currentLocale {
    NSString* identifier = [[NSLocale currentLocale] localeIdentifier];
    
    NSString *currentLanguageCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
    if (currentLanguageCode) {
        identifier = currentLanguageCode;
    }
    
    return [NSLocale localeWithLocaleIdentifier:identifier];
}
@end
