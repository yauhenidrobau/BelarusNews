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
#import "Constants.h"

typedef void(^DataLoadCallback)(NSData *info, NSError* error);

@interface RemoteFacade ()

@property (nonatomic, strong) NSData *info;
@property (nonatomic, strong) NSString *feedIdString;
@property (nonatomic, strong) NSOperationQueue *operationQueue;


@end

@implementation RemoteFacade

SINGLETON(RemoteFacade)

-(void)loadData:(NSString *)urlString callback:(DataLoadCallback)completion {
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
    
    self.operationQueue = [NSOperationQueue new];
    [self.operationQueue setMaxConcurrentOperationCount:1];
    
//    if ([urlArray isKindOfClass:[NSArray class]]) {
//        array = [NSArray array];
//    } else {
//        array = urlArray;
//    }
    
//    if (dict.allKeys.count < 2) {
//        if (urlArray[0]) {
            NSURL *URL = [NSURL URLWithString:urlString];
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    __weak __typeof(self) wself = self;
                    wself.info = (NSData *)responseObject;
                    if(completion) {
                        completion(wself.info, nil);
                    }
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            [self.operationQueue addOperation:operation];

//    } else {
//        NSArray *values = dict.allValues;
//        NSArray *keys = dict.allKeys;
//    if (keys[0]) {
//        NSURL *URL = [NSURL URLWithString:values[0]];
//        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                __weak __typeof(self) wself = self;
//                wself.info = (NSData *)responseObject;
//                wself.feedIdString = keys[0];
//                if(completion) {
//                    completion(wself.info,wself.feedIdString, nil);
//                }
//            }];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
//        [self.operationQueue addOperation:operation];
//        
//    }
//    if (keys[1]) {
//        NSURL *URL = [NSURL URLWithString:values[1]];
//        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                __weak __typeof(self) wself = self;
//                wself.feedIdString = keys[1];
//                wself.info = (NSData *)responseObject;
//                if(completion) {
//                    completion(wself.info,wself.feedIdString, nil);
//                }
//            }];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
//        [self.operationQueue addOperation:operation];
//        
//    }
//        if (keys[2]) {
//            NSURL *URL = [NSURL URLWithString:values[2]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[2];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[3]) {
//            NSURL *URL = [NSURL URLWithString:values[3]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[3];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[4]) {
//            NSURL *URL = [NSURL URLWithString:values[4]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[4];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[5]) {
//            NSURL *URL = [NSURL URLWithString:values[5]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[5];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[6]) {
//            NSURL *URL = [NSURL URLWithString:values[6]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[6];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[7]) {
//            NSURL *URL = [NSURL URLWithString:values[7]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[7];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[8]) {
//            NSURL *URL = [NSURL URLWithString:values[8]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[8];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[9]) {
//            NSURL *URL = [NSURL URLWithString:values[9]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[9];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[10]) {
//            NSURL *URL = [NSURL URLWithString:values[10]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[10];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//        if (keys[11]) {
//            NSURL *URL = [NSURL URLWithString:values[11]];
//            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    __weak __typeof(self) wself = self;
//                    wself.feedIdString = keys[11];
//                    wself.info = (NSData *)responseObject;
//                    if(completion) {
//                        completion(wself.info,wself.feedIdString, nil);
//                    }
//                }];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//            }];
//            [self.operationQueue addOperation:operation];
//            
//        }
//    }
}

@end
