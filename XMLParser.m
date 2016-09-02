//
//  XMLParser.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "XMLParser.h"
#import <Foundation/Foundation.h>


@implementation XMLParser 

    //MARK: Properties
    
    +(XMLParser *) sharedInstance{
        static dispatch_once_t pred;
        static XMLParser * shared = nil;
        
        dispatch_once(&pred, ^{
            shared = [[XMLParser alloc] init];
        });
        return shared;
    }
    NSMutableDictionary *dictParsedData;
    NSDictionary *currentDataDictionary;
    NSString *currentElement;
    NSString *foundCharacters;
    NSString *titleFeed;
    NSString *descriptionFeed;
    NSString *pubDateFeed;
    NSMutableString *linkFeed;
    NSString *urlImage;

//XMLParser<NSXMLParserDelegate> *parserDelegate = [parserDelegate conformsToProtocol:NSXMLParserDelegate];


//MARK: Lifestyle

    
-(void) parseData:(NSData *) data {
    dictParsedData = [[NSMutableDictionary<NSString *, NSString *> alloc]init];
    NSXMLParser *parser =[[NSXMLParser alloc]initWithData:data];
        parser.delegate = self;
        [parser parse ];
    }


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    currentElement = elementName;
    if ([elementName isEqualToString:@"item"]) {
    
        currentDataDictionary = [[NSDictionary<NSString *, NSString *> alloc]init];
        titleFeed = @"";
        descriptionFeed = @"";
        pubDateFeed = @"";
        linkFeed = [[NSMutableString alloc]init];
        urlImage = @"";
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    //save data
    if ([elementName isEqualToString:@"item"]) {
        
        if (![titleFeed  isEqual: @""]) {
           titleFeed = [currentDataDictionary  objectForKey:@"title"];
            
        }
        
        if (![linkFeed isEqual:@"" ]) {
            // must get 0 element
            linkFeed  = [currentDataDictionary objectForKey:@"link"];
        }
        
        if (![descriptionFeed  isEqual: @""]) {
            
            descriptionFeed = [currentDataDictionary objectForKey:@"description"];

        }
        
        if (![pubDateFeed  isEqual: @""]) {
            pubDateFeed = [currentDataDictionary objectForKey:@"pubDate"];
        }
        
        if (![urlImage  isEqual: @""]){
            urlImage = [currentDataDictionary objectForKey:@"url"];
        }
        [dictParsedData addEntriesFromDictionary:currentDataDictionary];
    }
}   
    
   - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
        
        if ([currentElement  isEqual: @"title"]) {
            [titleFeed stringByAppendingString: string];
        } else if ([currentElement  isEqual: @"description"]) {
            [descriptionFeed stringByAppendingString:string];
        } else if ([currentElement  isEqual: @"link"] && linkFeed.length == 0){
            [linkFeed appendString: string];
        } else if ([currentElement  isEqual: @"pubDate"]) {
           [ pubDateFeed stringByAppendingString:string ];
        } else if ([currentElement  isEqual: @"url"] && urlImage.length == 0){
            [urlImage stringByAppendingString: string];
        }
    }
    
    
    
    
    
    // MARK: NSXMLParserDelegate
    - (void)parserDidEndDocument:(NSXMLParser *)parser {
        [ _xmlParserDelegate xmlParserDidFinishParsing:dictParsedData error:nil];
        
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
