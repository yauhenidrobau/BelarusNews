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
#import "CoreDataManager.h"
#import "Constants.h"


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



-(void) updateData {
    Constants *constant = [[Constants alloc]init];
    [constant initUrl];
    [[RemoteFacade sharedInstance] loadData:[constant url] callback:^(NSData *info, NSError *error) {
        if (error || !info) {
            //TODO: handle error
        } else {
            [[ParserManager sharedInstance] parseXmlData:info callback:^(NSData * dict, NSError *error) {
       
                [[CoreDataManager sharedInstance]saveFilms:dict];
            }];
        }
        
              
    }];

}
@end
