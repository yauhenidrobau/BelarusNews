//
//  ForecastManager.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 2/22/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityObject.h"

typedef void (^ForeCastBlock)(CityObject *cityObject, NSError *error);

@interface ForecastManager : NSObject

+(id)sharedInstance;
-(void)getWeatherWithCompletion:(ForeCastBlock)completion;

@end
