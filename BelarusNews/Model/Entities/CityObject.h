//
//  CityObject.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/24/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CityObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic) NSInteger cityID;
@property (nonatomic) NSInteger humidity;
@property (nonatomic) NSInteger pressure;
@property (nonatomic) NSInteger temperature;
@property (nonatomic) NSInteger windSpeed;
@property (nonatomic, strong) NSString *mainWeather;
@property (nonatomic, strong) NSString *mainWeatherIcon;
@property (nonatomic, strong) NSString *mainWeatherDescription;
@property (nonatomic) NSInteger weatherID;

@property (nonatomic) float lat;
@property (nonatomic) float lon;

-(void)updateWithDictionary:(NSDictionary*)dict;

@end
