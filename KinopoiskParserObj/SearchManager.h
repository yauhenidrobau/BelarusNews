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

@interface SearchManager : NSObject

+(instancetype)sharedInstance;
-(NSArray*)updateSearchResults:(NSString *)searchText forArray:(RLMResults<NewsEntity*>*)newsArray;
@end
