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
#warning comment - кое что забыл
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)updateSearchResults:(NSString *)searchText forArray:(NSArray*)newsArray withCompletion:(SearchDataCallback)completion {
    [self.operationQueue cancelAllOperations];
    NSOperation *operation = [[NSOperation alloc]init];
    __weak typeof (self)wself = self;
    [operation setCompletionBlock:^{
#warning Comment
        /*
         тебя не смущает, что поиск идет в главном потоке???
         не проще так сделать 
         [self.operationQueue addOperationWithBlock:^{
         
         }];
         */
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!searchText.length) {
            wself.searchResults = [newsArray mutableCopy];
            if (completion) {
                completion(wself.searchResults,nil);
            }
        } else {
            NSArray *searchResults = [NSMutableArray new];

                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"titleFeed contains[c] %@", searchText];
                searchResults = [newsArray filteredArrayUsingPredicate:resultPredicate];
                wself.searchResults = searchResults;
                if (completion) {
                    completion(wself.searchResults,nil);
                }
        }
        }];
    }];
    [self.operationQueue addOperation:operation];
}

@end
