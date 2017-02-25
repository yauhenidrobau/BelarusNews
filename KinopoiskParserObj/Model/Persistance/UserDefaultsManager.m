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

-(BOOL)boolForKey:(NSString *)key {
    return [self.userDefaults boolForKey:key];
}

-(void)setBool:(BOOL)boolean ForKey:(NSString *)key {
    [self.userDefaults setBool:boolean forKey:key];
    [self.userDefaults synchronize];
}

-(void)setObject:(id)object forKey:(NSString *)key {
    [self.userDefaults setObject:object forKey:key];
    [self.userDefaults synchronize];
}

-(id)objectForKey:(NSString *)key {
    return [self.userDefaults objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.userDefaults removeObjectForKey:key];
    [self.userDefaults synchronize];

}

-(NSInteger)integerForKey:(NSString*)key {
    return [self.userDefaults integerForKey:key];
}

-(void)setInteger:(NSInteger)integer forKey:(NSString *)key {
    [self.userDefaults setInteger:integer forKey:key];
    [self.userDefaults synchronize];
}
@end
