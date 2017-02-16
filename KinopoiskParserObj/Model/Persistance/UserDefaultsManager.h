//
//  UserDefaultsManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/16/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+(instancetype)sharedInstance;

-(BOOL)getBoolForKey:(NSString*)key;
-(void)setBool:(BOOL)boolean ForKey:(NSString *)key;

@end
