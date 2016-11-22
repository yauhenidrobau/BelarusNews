//
//  Constants.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "Constants.h"
@interface Constants()
@property(nonatomic,readwrite)NSString *url;

@end

@implementation Constants

-(NSString *)getURLByString:(NSString *)urlString{
    
 // url = @"http://kinosal.by/rss.xml";
 // url = @"http://film-ussr.ru/rss.php?c=22";
    // url = @"http://www.slamdunk.ru/rss/rss.html";

    url = @"https://st.kp.yandex.net/rss/news_premiers.rss";
    tutByUrl = @"http://news.tut.by/rss/all.rss";
    devBy = @"https://dev.by/rss";
    NSDictionary *urlDict = [NSDictionary dictionaryWithObjectsAndKeys:devBy,@"dev.by",tutByUrl,@"tut.by",url,@"yandex", nil];
    return [urlDict objectForKey:urlString];
}
@end
