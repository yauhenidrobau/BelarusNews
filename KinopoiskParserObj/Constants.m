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
@synthesize url;

-(void) initUrl{
    
    //url = @"http://kinosal.by/rss.xml";
    url = @"http://film-ussr.ru/rss.php?c=22";
  //url = @"https://st.kp.yandex.net/rss/news_premiers.rss";
}
@end
