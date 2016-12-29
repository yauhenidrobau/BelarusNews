//
//  DateFormatterManager.h
//  KinopoiskParserObj
//
//  Created by Admin on 07/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatterManager : NSDateFormatter

+(instancetype)sharedInstance;
- (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat;
- (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)dateFormat;

@end
