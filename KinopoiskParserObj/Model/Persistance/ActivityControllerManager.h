//
//  ActivityControllerManager.h
//  KinopoiskParserObj
//
//  Created by Admin on 1/3/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Macros.h"

@interface ActivityControllerManager : NSObject

+(instancetype)sharedInstance;
-(void)presentActivityController:(NSString *)type;

@end
