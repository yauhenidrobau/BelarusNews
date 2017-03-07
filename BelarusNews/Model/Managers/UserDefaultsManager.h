//
//  UserDefaultsManager.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 2/16/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+(instancetype)sharedInstance;

-(void)setBool:(BOOL)boolean ForKey:(NSString *)key;
-(void)setObject:(id)object forKey:(NSString*)key;
-(void)setInteger:(NSInteger)integer forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

-(BOOL)boolForKey:(NSString *)key;
-(id)objectForKey:(NSString *)key;
-(NSInteger)integerForKey:(NSString*)key;

@end
