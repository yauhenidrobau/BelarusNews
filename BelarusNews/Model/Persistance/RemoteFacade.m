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

-(instancetype)init {
    self = [super init];
    if (self) {
        self.operationQueue = [NSOperationQueue new];
        [self.operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}
-(void)loadData:(NSString *)urlString callback:(DataLoadCallback)completion {
    // load data
    [self.operationQueue cancelAllOperations];
    
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
}
  
@end
