//
//  DataManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpdateDataCallback)(NSError *error);

#define YANDEX_NEWS @"https://st.kp.yandex.net/rss/news_premiers.rss"
#define MTS_BY_NEWS @"http://www.mts.by/rss/"
#define TUT_BY_NEWS @"http://news.tut.by/rss/all.rss"
#define DEV_BY_NEWS @"https://dev.by/rss"

@interface DataManager : NSObject

+(instancetype)sharedInstance;
-(void)updateDataWithURLArray:(NSArray *)urlArray WithCallBack:(UpdateDataCallback)completionHandler;
@end
