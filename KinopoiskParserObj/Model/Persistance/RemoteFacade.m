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
#import <AFNetworking/AFNetworking.h>

typedef void(^DataLoadCallback)(NSData *info, NSError* error);

@interface RemoteFacade ()

@property (nonatomic, strong) NSData *info;

@end

@implementation RemoteFacade

SINGLETON(RemoteFacade)

-(void)loadData:(NSArray *)urlArray callback:(DataLoadCallback)completion {
    // load data
#warning AFNetworking - очень рекомендую разобраться
    
//    // First variant
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    
//    AFURLConnectionOperation *operation = [[AFURLConnectionOperation alloc] initWithRequest:request];
//    __weak __typeof(self)wself = self;
//    __weak __typeof(operation)woperation = operation;
//    [operation setCompletionBlock:^{
//        wself.info = woperation.responseData;
//        if (completion) {
//            completion(wself.info,nil);
//        }
//    }];
//    [operation start];
    
    
     // Second variant
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue setMaxConcurrentOperationCount:1];
    for (NSString *urlString in urlArray) {
        NSURL *URL = [NSURL URLWithString:urlString];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __weak __typeof(self) wself = self;
            wself.info = (NSData *)responseObject;
            if(completion) {
                completion(wself.info,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operationQueue addOperation:operation];
    }
   
}

@end
