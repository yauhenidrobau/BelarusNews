//
//  RemoteFacade.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "RemoteFacade.h"
#import "ParserManager.h"

typedef void (^DataLoadCallback)(NSData *info, NSError* error);

@interface RemoteFacade ()

@property (nonatomic, strong) NSData *info;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *>*infoDict;

@end

@implementation RemoteFacade


//singleton
+(RemoteFacade *) sharedInstance {
    static dispatch_once_t pred;
    static RemoteFacade *shared;
    dispatch_once(&pred, ^ {
        shared = [[RemoteFacade alloc]init];
    });
    return shared;
}


-(void) loadData:(NSString *)dataURL callback:(DataLoadCallback)comptetion {
    // load data
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
