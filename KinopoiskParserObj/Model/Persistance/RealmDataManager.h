//
//  RealmDataManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 17/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Macros.h"
#import "NewsEntity.h"

#warning correct callback
typedef void(^RealmDataManagerSaveCallback)(NSError* error);

@interface RealmDataManager : NSObject
+ (instancetype)sharedInstance;

-(void)saveNews:(NSArray<NSDictionary *>*)receivedNewsArray withServiceString:(NSString *)serviceString;
-(void)updateEntity:(NewsEntity *)entity WithProperty:(NSString*)property;
-(NSArray*)getFavoritesArray;
-(NSArray*)getAllOjbects;
-(NSArray*)RLMResultsToArray:(RLMResults *)results;
@end
