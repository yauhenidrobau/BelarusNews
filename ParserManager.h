//
//  ParserManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

typedef void (^ParseCallback)(NSArray<NSDictionary*>* info, NSError* error);

@interface ParserManager : NSObject
+(instancetype)sharedInstance;
-(void) parseXmlData:(NSData *)data callback:(ParseCallback)completion;
@end
