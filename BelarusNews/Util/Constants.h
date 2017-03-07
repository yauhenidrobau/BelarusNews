//
//  Constants.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

//API WEATHER
#define API_KEY @"http://api.openweathermap.org/data/2.5/forecast/city?"
#define APPID_KEY @"9df448a477adb11548e56edbefd9d879"

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
#define S13_NEWS @"http://megacat.by/rss-109"
#define NOVY_CHAS_NEWS @"http://megacat.by/rss-465"

#define YANDEX_METRICE_API_KEY @"ef1d79fb-d889-4ce0-96eb-83c62a3adfd2"
#define GOOGLE_PLACES_KEY @"AIzaSyB6SYasED7O-tRz3zEPRwHf846Q6DZfjYg"

#define OFFLINE_MODE @"OfflineMode"
#define NOTIFICATIONS_MODE @"NotificationsMode"
#define AUTOUPDATE_MODE @"Autoupdate"
#define NIGHT_MODE @"NightMode"
#define ROUND_IMAGES @"RoundImages"
#define CURRENT_CITY @"CurrentCity"
#define CITY_FORECAST @"CityForecast"

#define MAIN_COLOR RGB(81,255,181)

#define NO_INTERNET_KEY @"NoInternet"
#define TEST_HOST @"http:www.google.by"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)


typedef enum {
    SettingsCellTypeOffline = 151,
    SettingsCellTypeNotification = 152,
    SettingsCellTypeAutoupdate = 153,
    SettingsCellTypeNightMode = 154
}SettingsCells;

@interface Constants : NSObject

@end
