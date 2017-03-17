//
//  RealmDataManager.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 17/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Macros.h"
#import "NewsEntity.h"

typedef void(^RealmDataManagerSaveCallback)(NSError* error);

@interface RealmDataManager : NSObject
+ (instancetype)sharedInstance;

-(void)saveNews:(NSArray<NSDictionary *>*)receivedNewsArray withCategory:(NSString *)category andSource:(NSString*)source andCallBack:(RealmDataManagerSaveCallback)callback;
-(void)updateEntity:(NewsEntity *)entity WithProperty:(NSString*)property;
-(NSArray*)getFavoritesArray;
-(NSArray*)getAllOjbects;
-(NSArray *)getObjectsForEntity:(NSString *)predicat;
-(NSArray*)RLMResultsToArray:(RLMResults *)results;
@end
