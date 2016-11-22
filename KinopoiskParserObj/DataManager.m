//
//  DataManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//


#import "DataManager.h"

#import "RemoteFacade.h"
#import "ParserManager.h"
#import "Constants.h"
#import "RealmDataManager.h"

@implementation DataManager
@synthesize infoDict;

+(DataManager *) sharedInstance{
    static dispatch_once_t pred;
    static DataManager * shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[DataManager alloc] init];
    });
    return shared;
}

-(void) updateDataWithURLString:(NSString *)urlString AndCallBack:(UpdateDataCallback)completionHandler {
#warning зачем создавать константы? Сделай статическим
    Constants *constant = [Constants new];
    [[RemoteFacade sharedInstance] loadData:[constant getURLByString:urlString] callback:^(NSData *info, NSError *error) {
        if (error || !info) {
            //TODO: handle error
        } else {
            [[ParserManager sharedInstance] parseXmlData:info callback:^(NSData * dict, NSError *error) {
                [[RealmDataManager sharedInstance]saveNews:dict withServiceString:urlString];
                if (completionHandler) {
                    completionHandler(error);
                }
            }];
        }
    }];
}
@end
