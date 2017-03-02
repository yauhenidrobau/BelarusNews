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
#import "DateFormatterManager.h"

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
NSMutableDictionary *CDDateDict;

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
    if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"atom"]) {
        
        currentDataDictionary = [[NSMutableDictionary<NSString *, NSString *> alloc]init];
        titleFeed = [[NSMutableString alloc]initWithString:@""];
        
        descriptionFeed =  [[NSMutableString alloc] initWithString: @""];
        pubDateFeed = [[NSMutableString alloc] initWithString: @""];
        linkFeed = [NSMutableString new];
        CDDateDict = [[NSMutableDictionary alloc] init];
        urlImage = [[NSMutableString alloc] initWithString: @""];
    }
    if ([elementName isEqualToString:@"media:thumbnail"]) {
        urlImage = [[NSMutableString alloc] initWithString: attributeDict[@"url"]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
     NSString *someString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [CDDateDict setObject:someString forKey:currentElement];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *temp =  CDDateDict[currentElement]? CDDateDict[currentElement] : string;
    
    if ([currentElement  isEqual: @"title"]) {
        [titleFeed appendString: temp];
    } else if ([currentElement  isEqual: @"description"]) {
        [descriptionFeed appendString:temp];
    } else if ([currentElement  isEqual: @"link"] && linkFeed.length == 0){
        [linkFeed appendString:temp];
    } else if ([currentElement  isEqual: @"pubDate"]) {
        if (!pubDateFeed.length) {
            [ pubDateFeed  appendString:temp ];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    //save data
    if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"atom"]) {
        if (titleFeed.length) {
            titleFeed.string = [titleFeed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            titleFeed.string = [self stringByStrippingHTML:titleFeed];
            [currentDataDictionary  setObject:titleFeed forKey:@"title"];
        }
        if (linkFeed.length) {
            [currentDataDictionary  setObject:linkFeed forKey:@"link"];
        }
        if (descriptionFeed.length) {
            NSString *temp = [self getImageUrlFromDescription:descriptionFeed];
            descriptionFeed.string = [self stringByStrippingHTML:descriptionFeed];

            if (!urlImage.length) {
                if (temp.length) {
                    [urlImage appendString:temp];
                } else {
                    urlImage = [NSMutableString stringWithString:@""];
                }
            }
//            descriptionFeed =[NSMutableString stringWithString:[self getDescriptionString:descriptionFeed]];
            [currentDataDictionary  setObject:descriptionFeed forKey:@"description"];
            
        }
        if (urlImage.length) {
            [currentDataDictionary  setObject:urlImage forKey:@"imageUrl"];
        }
        if (pubDateFeed.length) {
            
            NSDate *pubDate = [[DateFormatterManager sharedInstance] dateFromString:[pubDateFeed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] withFormat:@"E, d MMM yyyy HH:mm:ss ZZZ"];
            if (pubDate) {
                currentDataDictionary[@"pubDate"] = pubDate;
            }
        }
        [dictParsedData addObject:currentDataDictionary];
        urlImage = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSArray<NSDictionary *> *parsedDataArray = [NSArray<NSDictionary*> arrayWithArray:dictParsedData];
    [ _xmlParserDelegate xmlParserDidFinishParsing:parsedDataArray error:nil];
    
}

-(NSString *)getImageUrlFromDescription:(NSMutableString *)descriptionFeed {
    NSRange range = [descriptionFeed rangeOfString:@"https://" options:NSCaseInsensitiveSearch];
    NSRange sRange = [descriptionFeed rangeOfString:@"http://" options:NSCaseInsensitiveSearch];

    NSString *finalUrlstring = @"";
    NSString *urlString;
    
    if (range.location != NSNotFound && range.location < 20) {
      urlString = [descriptionFeed substringFromIndex:range.location];
    } else if (sRange.location != NSNotFound && sRange.location < 20) {
         urlString = [descriptionFeed substringFromIndex:sRange.location];
    }
    NSArray *urlStrArray = [urlString componentsSeparatedByString:@" "];
    finalUrlstring = [urlStrArray[0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return finalUrlstring;
}

-(NSString *)getDescriptionString:(NSMutableString *)descriptionFeed {
    NSString *urlString;
    NSArray *urlStrArray;
    //get description for TUT.BY
    NSRange range = [descriptionFeed rangeOfString:@"/>" options:NSCaseInsensitiveSearch];
    if (range.location < 1000) {

    urlString = [descriptionFeed substringFromIndex:range.location];
    urlString = [urlString substringFromIndex:2];
    urlStrArray = [urlString componentsSeparatedByString:@"<br"];
    } else if (range.location > 1000) {
        
        // get description for DEV.BY
        range = [descriptionFeed rangeOfString:@"<div><p>" options:NSCaseInsensitiveSearch];
        if (range.location > 1000) {
            // get description for MTS.BY
            range = [descriptionFeed rangeOfString:@"<p><b>" options:NSCaseInsensitiveSearch];
            if (range.location > 1000) {
                range = [descriptionFeed rangeOfString:@"<p>" options:NSCaseInsensitiveSearch];
                if (range.location > 1000) {
                // get description for PRAVO.BY
                urlString = [descriptionFeed substringFromIndex:range.location];
                urlString = [urlString substringFromIndex:0];
                } else {
                    // get description for MTS.BY
                    urlString = [descriptionFeed substringFromIndex:range.location];
                    urlString = [urlString substringFromIndex:3];
                    urlStrArray = [urlString componentsSeparatedByString:@"</p>"];
                }
            } else {
            urlString = [descriptionFeed substringFromIndex:range.location];
            urlString = [urlString substringFromIndex:6];
            urlStrArray = [urlString componentsSeparatedByString:@" </b></p>"];
            }
            
        } else {
            urlString = [descriptionFeed substringFromIndex:range.location];
            urlString = [urlString substringFromIndex:8];
            urlStrArray = [urlString componentsSeparatedByString:@", <a"];
        }
    }
    
    
    return [self stringByStrippingHTML:urlStrArray[0]];
   
}

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"Читать далее" withString:@""];
    
    
    return str;
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
