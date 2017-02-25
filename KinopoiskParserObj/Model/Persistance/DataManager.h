//
//  DataManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityObject.h"

typedef void(^UpdateDataCallback)(NSError *error);
typedef void (^UpdateWeatherForecast)(CityObject *cityObject, NSError *error);

@interface DataManager : NSObject

+(instancetype)sharedInstance;
-(void)updateDataWithURLString:(NSString *)urlString AndTitle:(NSString *)title WithCallBack:(UpdateDataCallback)completionHandler;
-(void)updateWeatherForecastWithCallback:(UpdateWeatherForecast)callBback;

@end
