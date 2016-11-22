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

#warning Посмотри в Sunbird как там синглтон реализован через макрос
+(RealmDataManager *)sharedInstance {
    static dispatch_once_t pred;
    static RealmDataManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[RealmDataManager alloc]init];
    });
    return shared;
}

-(void)saveNews:(NSArray<NSDictionary *>*)newsDict withServiceString:(NSString *)urlString {
    RLMRealm *realm = [RLMRealm defaultRealm];
#warning если тебе нужен индекс i только для того, чтобы получить элемент из массива, то лучше сделать через forin
//    for (NSDictionary *dict in newsDict) {
    for (NSInteger i = 0; i < newsDict.count;i++) {
        NSDictionary *dict = newsDict[i];
        @try {
            [realm beginWriteTransaction];
            NewsEntity *currentNews = [[NewsEntity alloc]init];
            currentNews.feedIdString = urlString;
#warning почитай про modern obj c. Ты постоянно используешь objectForKey, зачем? если можно просто dict[@"title"];
            currentNews.titleFeed = [dict objectForKey:@"title"];
            currentNews.pubDateFeed = [dict objectForKey:@"pubDate"];
            currentNews.descriptionFeed = [dict objectForKey:@"description"];
            currentNews.linkFeed = [dict objectForKey:@"link"];
            if ([dict objectForKey:@"imageUrl"]) {
                currentNews.urlImage = [dict objectForKey:@"imageUrl"];
            }
            [realm addOrUpdateObject:currentNews];
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
@end
