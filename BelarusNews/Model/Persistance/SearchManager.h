//
//  SearchManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 05/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "NewsEntity.h"

typedef void(^SearchDataCallback)(NSArray *searchResults,NSError *error);

@interface SearchManager : NSObject

+(instancetype)sharedInstance;
-(void)updateSearchResults:(NSString *)searchText forArray:(NSArray*)newsArray withCompletion:(SearchDataCallback)completion;
@end
