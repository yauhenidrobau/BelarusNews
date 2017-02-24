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

typedef void (^ForeCastBlock)(NSArray *weatherArray, NSError *error);

@implementation ForecastManager


//-(void)getWeatherWithCompletion:(ForeCastBlock)completion {
//    NSInteger cityID = [SettingsManager sharedInstance].cityID.integerValue;
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
//    NSString *requestString = [NSString stringWithFormat:@"%@id=%d&APPID=%@",API_KEY,cityID,APPID_KEY];
//}
@end
