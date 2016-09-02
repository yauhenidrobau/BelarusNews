//
//  XMLParser.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/Coredata.h>
#import <UIKit/UIKit.h>

@protocol XMLParserDelegate
-(void) xmlParserDidFinishParsing: (NSDictionary<NSString *, NSString *>*)items  error: (NSError *)error;


@end
@interface XMLParser : NSObject <NSXMLParserDelegate>

@property(nonatomic, weak) id <XMLParserDelegate> xmlParserDelegate;
-(void) parseData:(NSData *) data;
+(XMLParser *) sharedInstance;

@end
