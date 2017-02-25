//
//  CityObject.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/24/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "CityObject.h"


#define kCityNameKey @"name"
#define kCityIDKey @"cityID"
#define kLatKey @"lat"
#define kLonKey @"lon"
#define kHumidityKey @"humidity"
#define kPressureKey @"pressure"
#define kTemperatureKey @"temperature"
#define kWinSpeedKey @"winSpeed"
#define kWeatherDescriptionKey @"weatherDescription"
#define kIconKey @"icon"
#define kMainWeatherKey @"mainWeather"

@interface CityObject ()

@end

@implementation CityObject

-(id)init {
    self = [super init];
    if (self) {
        self.cityName = @"";
        self.mainWeather = @"";
        self.mainWeatherIcon = @"";
        self.mainWeatherDescription = @"";
        self.windSpeed = 0;
        self.temperature = 0;
        self.pressure = 0;
        self.humidity = 0;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *cityName = [aDecoder decodeObjectForKey:kCityNameKey];
    NSString *weatherDescription =  [aDecoder decodeObjectForKey:kWeatherDescriptionKey];
    NSString *weatherIcon = [aDecoder decodeObjectForKey:kIconKey];
    NSString *mainWeather = [aDecoder decodeObjectForKey:kMainWeatherKey];
    NSInteger cityID = [aDecoder decodeIntegerForKey:kCityIDKey];
    float lat =  [aDecoder decodeFloatForKey:kLatKey];
    float lon = [aDecoder decodeFloatForKey:kLonKey];
    NSInteger humidity = [aDecoder decodeIntegerForKey:kHumidityKey];
    NSInteger pressure = [aDecoder decodeIntegerForKey:kPressureKey];
    NSInteger temperature = [aDecoder decodeIntegerForKey:kTemperatureKey];
    NSInteger windSpeed = [aDecoder decodeIntegerForKey:kWinSpeedKey];
    CityObject *object = [CityObject new];
    object.cityName = cityName;
    object.mainWeatherDescription = weatherDescription;
    object.mainWeatherIcon = weatherIcon;
    object.mainWeather = mainWeather;
    object.cityID = cityID;
    object.lat = lat;
    object.lon = lon;
    object.humidity = humidity;
    object.pressure = pressure;
    object.windSpeed = windSpeed;
    object.temperature = temperature;
    
    return object;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_cityName forKey:kCityNameKey];
    [aCoder encodeObject:_mainWeatherDescription forKey:kWeatherDescriptionKey];
    [aCoder encodeObject:_mainWeatherIcon forKey:kIconKey];
    [aCoder encodeObject:_mainWeather forKey:kMainWeatherKey];
    [aCoder encodeInteger:_cityID forKey:kCityIDKey];
    [aCoder encodeFloat:_lat forKey:kLatKey];
    [aCoder encodeFloat:_lon forKey:kLonKey];
    [aCoder encodeInteger:_humidity forKey:kHumidityKey];
    [aCoder encodeInteger:_pressure forKey:kPressureKey];
    [aCoder encodeInteger:_temperature forKey:kTemperatureKey];
    [aCoder encodeInteger:_windSpeed forKey:kWinSpeedKey];
}

-(void)updateWithDictionary:(NSDictionary *)dict {

    NSNumber *ID = dict[@"id"];
    NSNumber * humidityNumber = dict[@"main"][@"humidity"];
    NSDictionary *coord = dict[@"coord"];
    NSNumber *lat = coord[@"lat"];
    NSNumber *lon = coord[@"lon"];
    NSNumber *pressureNumber = dict[@"main"][@"pressure"];
    NSNumber *temperatureNumber = dict[@"main"][@"temp"];
    NSNumber *windSpeedNumber = dict[@"wind"][@"speed"];
    
    self.cityID = ID.integerValue;
    self.cityName = dict[@"name"]; 
    self.lat = lat.floatValue;
    self.lon = lon.floatValue;
    self.humidity = humidityNumber.integerValue;
    self.pressure = pressureNumber.integerValue;
    self.temperature = temperatureNumber.integerValue;
    self.mainWeather = dict[@"weather"][0][@"main"];
    self.mainWeatherIcon = dict[@"weather"][0][@"icon"];
    self.mainWeatherDescription = dict[@"weather"][0][@"description"];;
    self.windSpeed = windSpeedNumber.integerValue;

}
@end
