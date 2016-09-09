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
    NSMutableDictionary *currentDataDictionary;
    NSString *currentElement;
    NSMutableString *foundCharacters;
    NSMutableString *titleFeed;
    NSMutableString *descriptionFeed;
    NSMutableString *pubDateFeed;
    NSMutableString *linkFeed;
    NSMutableString *urlImage;
    NSMutableString * tempString;

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

        currentDataDictionary = [[NSMutableDictionary<NSString *, NSString *> alloc]init];
        titleFeed =[[NSMutableString alloc]initWithString:@""];
        
        descriptionFeed =  [[NSMutableString alloc] initWithString: @""];
        pubDateFeed = [[NSMutableString alloc] initWithString: @""];
        linkFeed = [[NSMutableString alloc]init];
        urlImage = [[NSMutableString alloc] initWithString: @""];
        tempString = [[NSMutableString alloc] initWithString: @""];
    }
    }
    - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    //save data
    if ([elementName isEqualToString:@"item"]) {
        
        if (![titleFeed  isEqual: @""]) {
            [currentDataDictionary  setObject:titleFeed forKey:@"title"];
            
        }
        
        if (![linkFeed isEqual:@"" ]) {
            // must get 0 element
            [currentDataDictionary  setObject:linkFeed forKey:@"link"];
        }
        
        
        if (![descriptionFeed  isEqual: @""]) {
            
            [currentDataDictionary  setObject:descriptionFeed forKey:@"description"];

        }
        
        if (![pubDateFeed  isEqual: @""]) {
            [currentDataDictionary  setObject:pubDateFeed forKey:@"pubDate"];
        }
        NSRange match;
        match = [tempString rangeOfString:@"<p><img src="];
        //match = [tempString rangeOfString: @"|"];
        
        
         if (match.location < 200) {
        if (tempString.length !=0) {
            if (match.length == 12) {
                NSString *cdataString = [tempString substringWithRange:NSMakeRange(match.length + 1,match.location + 50 )];
                [urlImage appendString:cdataString];
            }

        }
        }
        
        /*
        if (match.location < 200) {
            if (tempString.length !=0) {
                if (match.length == 12) {
                    NSString *cdataString = [tempString substringWithRange:NSMakeRange(match.length + 1,match.location + 50 )];
                    [urlImage appendString:cdataString];
                }
                
            }
        }
        
       */
        
        if (![urlImage  isEqual: @""]) {
            [currentDataDictionary  setObject:urlImage forKey:@"url"];
        }
    
        [dictParsedData setObject:currentDataDictionary forKey:currentDataDictionary[@"title"]];
    }
    }

    - (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
    {
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
           [ pubDateFeed appendString:string ];
        } else if ([currentElement  isEqual: @"url"] && urlImage.length == 0){
            [urlImage  appendString: string];
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
