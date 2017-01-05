//
//  DateFormatterManager.m
//  KinopoiskParserObj
//
//  Created by Admin on 07/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DateFormatterManager.h"
#import "Macros.h"

@interface DateFormatterManager ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DateFormatterManager

SINGLETON(DateFormatterManager)

-(instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    return self;
}

- (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat {
    if (!dateString.length) {
        return nil;
    }
    [self.dateFormatter setDateFormat:dateFormat];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)dateFormat {
    if (!date) {
        return nil;
    }
    [self.dateFormatter setDateFormat:dateFormat];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [self.dateFormatter stringFromDate:date];
}
@end
