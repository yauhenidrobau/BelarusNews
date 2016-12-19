//
//  RemoteFacade.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "RemoteFacade.h"

#import "ParserManager.h"
#import "DataManager.h"
#import "Macros.h"
#import <AFNetworking/AFNetworking.h>

typedef void(^DataLoadCallback)(NSData *info,NSString *feedIdString, NSError* error);

@interface RemoteFacade ()

@property (nonatomic, strong) NSData *info;
@property (nonatomic, strong) NSString *feedIdString;


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
    if (urlArray[0]) {
        NSURL *URL = [NSURL URLWithString:urlArray[0]];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __weak __typeof(self) wself = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                wself.info = (NSData *)responseObject;
                if ([urlArray[0] isEqualToString:PRAVO_BY_NEWS]) {
                    wself.feedIdString = NSLocalizedString(@"DEV.BY", nil);
                } else if ([urlArray[0] isEqualToString:NATIONAL_CENTER_PRAVO_NEWS]) {
                    wself.feedIdString = NSLocalizedString(@"TUT.BY", nil);
                } else {
                    wself.feedIdString = NSLocalizedString(@"MTS.BY", nil);
                }
                if(completion) {
                    completion(wself.info,wself.feedIdString, nil);
                }
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operationQueue addOperation:operation];
    } if (urlArray.count > 1) {
        NSURL *URL = [NSURL URLWithString:urlArray[1]];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __weak __typeof(self) wself = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                wself.info = (NSData *)responseObject;
                wself.feedIdString = NSLocalizedString(@"TUT.BY", nil);
                if(completion) {
                    completion(wself.info,wself.feedIdString, nil);
                }
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operationQueue addOperation:operation];
    } if (urlArray.count > 1) {
        NSURL *URL = [NSURL URLWithString:urlArray[2]];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __weak __typeof(self) wself = self;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                wself.info = (NSData *)responseObject;
                wself.feedIdString = NSLocalizedString(@"MTS.BY", nil);
                if(completion) {
                    completion(wself.info,wself.feedIdString, nil);
                }
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operationQueue addOperation:operation];
    }
}

@end
