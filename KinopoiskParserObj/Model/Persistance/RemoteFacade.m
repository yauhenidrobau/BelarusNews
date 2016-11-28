//
//  RemoteFacade.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "RemoteFacade.h"
#import "ParserManager.h"
#import "Macros.h"

typedef void(^DataLoadCallback)(NSData *info, NSError* error);

@interface RemoteFacade ()

@property (nonatomic, strong) NSData *info;

@end

@implementation RemoteFacade

SINGLETON(RemoteFacade)

-(void)loadData:(NSString *)dataURL callback:(DataLoadCallback)comptetion {
    // load data
#warning AFNetworking - очень рекомендую разобраться
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:dataURL];
        NSData *info = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (comptetion) {
                comptetion(info, nil);
            }
        });      
    });
}

@end
