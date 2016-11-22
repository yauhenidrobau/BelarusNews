//
//  Constants.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "Constants.h"
@interface Constants()
@property(nonatomic, readonly) NSString *yandexUrl;
@property(nonatomic,readonly) NSString *tutByUrl;
@property(nonatomic,readonly) NSString *devBy;
@end

@implementation Constants

-(NSString *)getURLByString:(NSString *)urlString{
    
 // url = @"http://kinosal.by/rss.xml";
 // url = @"http://film-ussr.ru/rss.php?c=22";
    // url = @"http://www.slamdunk.ru/rss/rss.html";

    _yandexUrl = @"https://st.kp.yandex.net/rss/news_premiers.rss";
    _tutByUrl = @"http://news.tut.by/rss/all.rss";
    _devBy = @"https://dev.by/rss";
    NSDictionary *urlDict = [NSDictionary dictionaryWithObjectsAndKeys:_devBy,@"dev.by",_tutByUrl,@"tut.by",_yandexUrl,@"yandex", nil];
    return [urlDict objectForKey:urlString];
}
@end
