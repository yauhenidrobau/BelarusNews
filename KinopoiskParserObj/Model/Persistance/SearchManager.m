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

-(void)updateSearchResults:(NSString *)searchText forArray:(NSArray*)newsArray withCompletion:(SearchDataCallback)completion {
    [self.operationQueue cancelAllOperations];
    NSOperation *operation = [[NSOperation alloc]init];
    [operation setCompletionBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!searchText.length) {
            self.searchResults = [newsArray mutableCopy];
            if (completion) {
                completion(self.searchResults,nil);
            }
        } else {
            NSArray *searchResults = [NSMutableArray new];
            for (NSInteger i = 0;i < newsArray.count;i++) {
                NewsEntity *entity = newsArray[i];
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"titleFeed contains[c] %@", searchText];
                searchResults = [newsArray filteredArrayUsingPredicate:resultPredicate];
                //            if ([entity.titleFeed containsString:searchText]) {
                //                [searchResults addObject:entity];
                //            }
            }
            self.searchResults = searchResults;
                if (completion) {
                    completion(self.searchResults,nil);
                }
        }
        }];
    }];
    [self.operationQueue addOperation:operation];
}

@end
