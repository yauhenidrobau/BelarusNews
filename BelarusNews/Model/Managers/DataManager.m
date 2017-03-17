//
//  DataManager.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//


#import "DataManager.h"

#import "RemoteFacade.h"
#import "ParserManager.h"
#import "Constants.h"
#import "RealmDataManager.h"
#import "Macros.h"
#import "ForecastManager.h"
#import "UserDefaultsManager.h"
#import "SettingsManager.h"
#import "Constants.h"

@interface DataManager ()

@property(nonatomic, strong) NSMutableDictionary<NSString *,NSString *> *infoDict;

@end

@implementation DataManager

SINGLETON(DataManager)

-(void)updateDataWithURLString:(NSString *)urlString andCategory:(NSString *)category andSource:(NSString *)source WithCallBack:(UpdateDataCallback)completionHandler {
    [[RemoteFacade sharedInstance] loadData:urlString callback:^(NSData *info, NSError *error) {
        if (error || !info) {
            //TODO: handle error
        } else {
            [[ParserManager sharedInstance] parseXmlData:info callback:^(NSArray<NSDictionary *>* newsArray, NSError *error) {
                [[RealmDataManager sharedInstance]saveNews:newsArray withCategory:category andSource:source andCallBack:^(NSError *saveError) {
                    if (!saveError) {
                        if (completionHandler) {
                            completionHandler(saveError);
                        }
                    }
                }];
                
            }];
            
        }
        
    }];
}

-(void)updateWeatherForecastWithCallback:(UpdateWeatherForecast)callBback {
    [[ForecastManager sharedInstance]getWeatherWithCompletion:^(CityObject *cityObject, NSError *error) {
        if (!error) {
            [[UserDefaultsManager sharedInstance]setObject:[NSKeyedArchiver archivedDataWithRootObject:cityObject] forKey:CITY_FORECAST];
            [SettingsManager sharedInstance].cityObject = cityObject;
            if (callBback) {
                callBback(cityObject,nil);
            }
        } else {
            if (callBback) {
                callBback(nil,error);
            }
        }
    }];
}
@end
