//
//  ParserManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "ParserManager.h"
#import "XMLParser.h"


@interface ParserManager () <XMLParserDelegate>

@property (nonatomic, copy) ParseCallback callback;

@property(nonatomic, strong) NSData *info;

@end

@implementation ParserManager

#warning дублирование кода
+(ParserManager *) sharedInstance {
    static dispatch_once_t pred;
    static ParserManager *shared = nil;
    dispatch_once(&pred, ^ {
        shared = [[ParserManager alloc]init];
    });
    return shared;
}



//   how to use blocks here
-(void) parseXmlData:(NSData *)data callback:(ParseCallback)completion {
   self.callback = completion;
    
    XMLParser *parser = [[XMLParser alloc]init];
    parser.xmlParserDelegate = self;
    [parser parseData:data ];
   
}

-(void) xmlParserDidFinishParsing: (NSArray<NSDictionary *>*)items  error: (NSError *)error{
    if (self.callback) {
        self.info = items;
        self.callback(self.info, nil);
    }

}


@end

