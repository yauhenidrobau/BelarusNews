//
//  XMLParser.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "XMLParser.h"
#import <Foundation/Foundation.h>
#import "Macros.h"

@implementation XMLParser 
SINGLETON(XMLParser)

NSMutableArray *dictParsedData;
NSMutableDictionary *currentDataDictionary;
NSString *currentElement;
NSMutableString *foundCharacters;
NSMutableString *titleFeed;
NSMutableString *descriptionFeed;
NSMutableString *pubDateFeed;
NSMutableString *linkFeed;
NSMutableString *urlImage;
NSMutableString * tempString;

#pragma mark - Lifecycle

- (void)parseData:(NSData *) data {
    dictParsedData = [NSMutableArray new];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    currentElement = elementName;
    if ([elementName isEqualToString:@"item"]) {

        currentDataDictionary = [[NSMutableDictionary<NSString *, NSString *> alloc]init];
        titleFeed = [[NSMutableString alloc]initWithString:@""];
        
        descriptionFeed =  [[NSMutableString alloc] initWithString: @""];
        pubDateFeed = [[NSMutableString alloc] initWithString: @""];
        linkFeed = [NSMutableString new];
        urlImage = [[NSMutableString alloc] initWithString: @""];
        tempString = [[NSMutableString alloc] initWithString: @""];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    //save data
    if ([elementName isEqualToString:@"item"]) {
        if (titleFeed.length) {
            [currentDataDictionary  setObject:titleFeed forKey:@"title"];
        }
        if (linkFeed.length) {
#warning must get 0 element

            // must get 0 element
            [currentDataDictionary  setObject:linkFeed forKey:@"link"];
        }
        if (descriptionFeed.length) {
            [currentDataDictionary  setObject:descriptionFeed forKey:@"description"];
        }
        if (pubDateFeed.length) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm"];

            NSDate *pubDate = [formatter dateFromString:[pubDateFeed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            if (pubDate) {
                currentDataDictionary[@"pubDate"] = pubDate;
            }
            
        }
        NSRange matchBegin = [descriptionFeed rangeOfString:@"<img src="];
        NSRange matchEnd = [descriptionFeed rangeOfString:@"width="];

         if (matchBegin.location < 200 && matchEnd.location < 200) {
            NSString *cdataString = [descriptionFeed substringWithRange:NSMakeRange(matchBegin.length + 1,matchEnd.location - 3  - matchBegin.length )];
             urlImage = [NSMutableString stringWithString:@""];
            [urlImage appendString:cdataString];
            }

        if (urlImage.length) {
            [currentDataDictionary  setObject:urlImage forKey:@"imageUrl"];
        }
        [dictParsedData addObject:currentDataDictionary];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
     NSString *someString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [tempString appendString:someString];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([currentElement  isEqual: @"title"]) {
        [titleFeed appendString: string];
    } else if ([currentElement  isEqual: @"description"]) {
        [descriptionFeed appendString:string];
    } else if ([currentElement  isEqual: @"link"] && linkFeed.length == 0){
        [linkFeed appendString: string];
    } else if ([currentElement  isEqual: @"pubDate"]) {
        if (!pubDateFeed.length) {
            [ pubDateFeed  appendString:string ];
        }
    }
}

#warning TODO what is it correct it
//XMLParser<NSXMLParserDelegate> *parserDelegate = [parserDelegate conformsToProtocol:NSXMLParserDelegate];


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSArray<NSDictionary *> *parsedDataArray = [NSArray<NSDictionary*> arrayWithArray:dictParsedData];
    [ _xmlParserDelegate xmlParserDidFinishParsing:parsedDataArray error:nil];
    
}
/*
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
print(parseError.description);
    
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    print(validationError.description);
}
*/








@end
