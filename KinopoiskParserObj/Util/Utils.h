//
//  Utils.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 09/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(void)exitFromApplication;

@end

@interface NSDateFormatter (Localized)

+ (NSDateFormatter *)newLocalized;

@end
