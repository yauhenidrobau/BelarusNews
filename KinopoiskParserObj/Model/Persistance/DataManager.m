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
#import "Macros.h"

@interface DataManager ()

@property(nonatomic, strong) NSMutableDictionary<NSString *,NSString *> *infoDict;

@end

@implementation DataManager

SINGLETON(DataManager)

-(void)updateDataWithURLArray:(NSArray *)urlArray AndTitleArray:(NSArray*)titleArray WithCallBack:(UpdateDataCallback)completionHandler {
    [[RemoteFacade sharedInstance] loadData:urlArray callback:^(NSData *info, NSError *error) {
        if (error || !info) {
            //TODO: handle error
        } else {
            [[ParserManager sharedInstance] parseXmlData:info callback:^(NSArray<NSDictionary *>* newsArray, NSError *error) {
                [[RealmDataManager sharedInstance]saveNews:newsArray withServiceArray:titleArray];
                if (completionHandler) {
                    completionHandler(error);
                }
            }];
            
        }
        
    }];
}
@end
