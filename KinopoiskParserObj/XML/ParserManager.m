//
//  ParserManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "ParserManager.h"

#import "XMLParser.h"
#import "Macros.h"

@interface ParserManager () <XMLParserDelegate>

@property (nonatomic, copy) ParseCallback callback;
@property(nonatomic, strong) NSArray<NSDictionary*> *info;

@end

@implementation ParserManager

SINGLETON(ParserManager)

//   how to use blocks here
-(void) parseXmlData:(NSData *)data callback:(ParseCallback)completion {
   self.callback = completion;
    XMLParser *parser = [[XMLParser alloc]init];
    parser.xmlParserDelegate = self;
    [parser parseData:data];
}

-(void) xmlParserDidFinishParsing: (NSData*)items  error: (NSError *)error{
    if (self.callback) {
#warning Ты в NSData присваиваешь массив!
        self.info = items;
#warning ОБЯЗАТЕЛЬНО ДОЛЖНА БЫТЬ ПРОВЕРКА НА СУЩЕСТВОВАНИЕ БЛОКА!!!!!!!!!
        if (self.callback) {
            self.callback(self.info, nil);
        } else {
            error = [NSError errorWithDomain:@"Error" code:-111 userInfo:nil];
            self.callback(nil,error);
        }
    }
}


@end

