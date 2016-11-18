//
//  RealmDataManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 17/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

typedef void (^RealmDataManagerSaveCallback)(NSError* error);

@interface RealmDataManager : NSObject
+(RealmDataManager *)sharedInstance;

-(void)saveNews:(NSArray<NSDictionary *>*)newsDict withServiceString:(NSString *)urlString;
@end
