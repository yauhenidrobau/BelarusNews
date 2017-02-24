//
//  CityObject.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/24/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "CityObject.h"

#import <CoreLocation/CoreLocation.h>

@interface CityObject ()

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic) CLLocationCoordinate2D cityCoordinates;
@property (nonatomic) NSNumber *cityID;
@end

@implementation CityObject

-(void)updateWithDictionary:(NSDictionary *)dict {
    self.cityName = dict[@"name"];
    self.countryName = dict[@"country"];
    self.cityID = dict[@"_id"];
    NSDictionary *coord = dict[@"coord"];
//    float lat = (float)coord[@"lat"];
//    float lon = (float)coord[@"lon"];
//    self.cityCoordinates = CLLocationCoordinate2DMake(lat, lon);
}
@end
