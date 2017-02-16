//
//  UserDefaultsManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 2/16/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "UserDefaultsManager.h"

#import "Macros.h"

@interface UserDefaultsManager ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation UserDefaultsManager

SINGLETON(UserDefaultsManager)

-(instancetype)init {
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(BOOL)getBoolForKey:(NSString *)key {
    return [self.userDefaults boolForKey:key];
}

-(void)setBool:(BOOL)boolean ForKey:(NSString *)key {
    [self.userDefaults setBool:boolean forKey:key];
}

@end
