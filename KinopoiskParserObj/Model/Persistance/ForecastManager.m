//
//  ForecastManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/22/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "ForecastManager.h"

#import "Constants.h"
#import "SettingsManager.h"
#import <AFNetworking.h>
#import "Macros.h"

@implementation ForecastManager
SINGLETON(ForecastManager)

-(void)getWeatherWithCompletion:(ForeCastBlock)completion {
    
    NSString *city = [SettingsManager sharedInstance].currentCity;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
    NSString *requestString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather"];
    NSDictionary *params = @{@"q" : city,
                             @"appid" : APPID_KEY};
    [manager GET:requestString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        CityObject *cityObject = [CityObject new];
        [cityObject updateWithDictionary:dict];
        if (completion) {
            completion(cityObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}
@end
