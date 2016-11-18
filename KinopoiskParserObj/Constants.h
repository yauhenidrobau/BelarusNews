//
//  Constants.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

@property(nonatomic, readonly) NSString *url;
@property(nonatomic,readonly) NSString *tutByUrl;
@property(nonatomic,readonly) NSString *devBy;
-(NSString *)getURLByString:(NSString *)urlString;
@end
