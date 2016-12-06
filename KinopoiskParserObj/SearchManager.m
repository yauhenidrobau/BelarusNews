//
//  SearchManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 05/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "SearchManager.h"

#import "Macros.h"

@interface SearchManager ()
@property (nonatomic, strong) NSArray *searchResults;
@end
@implementation SearchManager
SINGLETON(SearchManager)

-(NSArray*)updateSearchResults:(NSString *)searchText forArray:(RLMResults<NewsEntity*>*)newsArray {


    if (!searchText) {
        self.searchResults = [newsArray mutableCopy];
    } else {
        NSMutableArray *searchResults = [NSMutableArray new];
        for (NSInteger i = 0;i < newsArray.count;i++) {
            NewsEntity *entity = newsArray[i];
            if ([entity.titleFeed containsString:searchText]) {
                [searchResults addObject:entity];
            }
        }
        self.searchResults = searchResults;
    }
    return self.searchResults;
}

@end
