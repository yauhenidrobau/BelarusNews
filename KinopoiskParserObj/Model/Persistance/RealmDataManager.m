//
//  RealmDataManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 17/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "RealmDataManager.h"

#import "NewsEntity.h"

@implementation RealmDataManager

SINGLETON(RealmDataManager)

-(void)saveNews:(NSArray<NSDictionary *>*)receivedNewsArray withServiceString:(NSString *)serviceString{
    RLMRealm *realm = [RLMRealm defaultRealm];
    for (NSDictionary *dict in receivedNewsArray) {
        @try {
            [realm beginWriteTransaction];
            NewsEntity *currentNews = [self RLMResultsToArray:[NewsEntity objectsWhere:@"titleFeed == %@",dict[@"title"]]].firstObject;
            if (!currentNews) {
                currentNews = [NewsEntity new];
                currentNews.feedIdString = serviceString;
                currentNews.titleFeed = dict[@"title"];
                currentNews.pubDateFeed = dict[@"pubDate"];
                currentNews.descriptionFeed = dict[@"description"];
                currentNews.linkFeed = dict[@"link"];
                if (dict[@"imageUrl"]) {
                    currentNews.urlImage = dict[@"imageUrl"];
                }
                [realm addOrUpdateObject:currentNews];
            }
            [realm commitWriteTransaction];
        }
        @catch (NSException *exception) {
            NSLog(@"exception");
            if ([realm inWriteTransaction]) {
                [realm cancelWriteTransaction];
            }
        }
    }
}

-(void)updateEntity:(NewsEntity *)entity {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    entity.favorite = !entity.favorite;
    [realm addOrUpdateObject:entity];
    [realm commitWriteTransaction];
    NSLog(@"Saved Successfully");
}

-(NSArray*)getFavoritesArray{
    RLMResults *results = [NewsEntity allObjects];
    NSArray *allResultsArray = [self RLMResultsToArray:results];
    NSMutableArray *favoritesArray = [NSMutableArray array];
    for (NewsEntity *entity in allResultsArray) {
        if (entity.favorite) {
            [favoritesArray addObject:entity];
        }
    }
    return favoritesArray;
}

-(NSArray*)getAllOjbects{
    RLMResults *results = [NewsEntity allObjects];
    NSArray *allResultsArray = [self RLMResultsToArray:results];
    
    return allResultsArray;
}

-(NSArray*)RLMResultsToArray:(RLMResults *)results{
    NSMutableArray *array = [NSMutableArray array];
    for (RLMObject *object in results) {
        [array addObject:object];
    }
    return array;
}
@end
