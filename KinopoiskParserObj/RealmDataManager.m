//
//  RealmDataManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 17/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "RealmDataManager.h"

#import "NewsEntity.h"
#warning Зачем здесь импорт SDWebImage?
#import <SDWebImage/UIImageView+WebCache.h>

@implementation RealmDataManager

SINGLETON(RealmDataManager)

-(void)saveNews:(NSArray<NSDictionary *>*)receivedNewsArray withServiceString:(NSString *)urlString {
    RLMRealm *realm = [RLMRealm defaultRealm];
    for (NSDictionary *dict in receivedNewsArray) {
        @try {
            [realm beginWriteTransaction];
            NewsEntity *currentNews = [[NewsEntity alloc]init];
            currentNews.feedIdString = urlString;
            currentNews.titleFeed = dict[@"title"];
            currentNews.pubDateFeed = dict[@"pubDate"];
            currentNews.descriptionFeed = dict[@"description"];
            currentNews.linkFeed = dict[@"link"];
            if (dict[@"imageUrl"]) {
                currentNews.urlImage = dict[@"imageUrl"];
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
