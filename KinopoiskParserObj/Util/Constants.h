//
//  Constants.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

// TUT.BY
#define MAIN_NEWS @"https://news.tut.by/rss/index.rss"
#define ECONOMIC_NEWS @"https://news.tut.by/rss/economics.rss"
#define SOCIETY_NEWS @"https://news.tut.by/rss/society.rss"
#define WORLD_NEWS @"https://news.tut.by/rss/world.rss"
#define CULTURE_NEWS @"https://news.tut.by/rss/culture.rss"
#define ACCIDENT_NEWS @"https://news.tut.by/rss/accidents.rss"
#define FINANCE_NEWS @"https://news.tut.by/rss/finance.rss"
#define REALTY_NEWS @"https://news.tut.by/rss/realty/all.rss"
#define SPORT_NEWS @"https://news.tut.by/rss/sport/all.rss"
#define AUTO_NEWS @"https://news.tut.by/rss/auto/all.rss"
#define LADY_NEWS @"https://news.tut.by/rss/lady/all.rss"
#define SCIENCE_NEWS @"https://news.tut.by/rss/42/inbelarus.rss"

//Onliner
#define PEOPLE_ONLINER_LINK @"https://people.onliner.by/feed"
#define AUTO_ONLINER_LINK @"https://auto.onliner.by/feed"
#define TECH_ONLINER_NEWS @"https://tech.onliner.by/feed"
#define REALT_ONLINER_NEWS @"https://realt.onliner.by/feed"

#define DEV_BY_NEWS @"https://dev.by/rss"
#define YANDEX_NEWS @"https://st.kp.yandex.net/rss/news_premiers.rss"
#define MTS_BY_NEWS @"http://www.mts.by/rss/"
#define PRAVO_NEWS @"http://www.pravo.by/novosti/obshchestvenno-politicheskie-i-v-oblasti-prava/rss/"

#define YANDEX_METRICE_API_KEY @"ef1d79fb-d889-4ce0-96eb-83c62a3adfd2"

#define OFFLINE_MODE @"OfflineMode"
#define NOTIFICATIONS_MODE @"NotificationsMode"
#define AUTOUPDATE_MODE @"Autoupdate"
#define NIGHT_MODE @"NightMode"
#define ROUND_IMAGES @"RoundImages"

#define MAIN_COLOR RGB(81,255,181)

#define NO_INTERNET_KEY @"NoInternet"

typedef enum {
    SettingsCellTypeOffline = 151,
    SettingsCellTypeNotification = 152,
    SettingsCellTypeAutoupdate = 153,
    SettingsCellTypeNightMode = 154
}SettingsCells;

@interface Constants : NSObject

@end
