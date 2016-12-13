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
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end
@implementation SearchManager
SINGLETON(SearchManager)

-(instancetype)init {
    self = [super init];
    if (self) {
       self.operationQueue = [NSOperationQueue new];
    }
    return self;
}

-(NSArray*)updateSearchResults:(NSString *)searchText forArray:(NSArray*)newsArray {
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperationWithBlock:^{
    if (!searchText) {
        self.searchResults = [newsArray copy];
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
    }];
    return self.searchResults;
}

@end
