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

-(void)loadData:(NSString *)urlString callback:(DataLoadCallback)comptetion {
    // load data
#warning AFNetworking - очень рекомендую разобраться
//
//    NSURL *URL = [NSURL URLWithString:urlString];
//   NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:URL sessionConfiguration:configuration];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [request setValue:@"application/rss+xml" forHTTPHeaderField:@"content-type"];
//    [manager.requestSerializer setValue:@"application/rss+xml" forHTTPHeaderField:@"content-type"];
//    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/rss+xml"];
//    [manager setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
//    NSURLSessionDataTask *dataTask = [manager  GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        self.info = (NSData *)responseObject;
//        if (comptetion) {
//            comptetion(self.info, nil);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        self.info = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        if (comptetion) {
//            comptetion(self.info, nil);
//        }
//    }];
//        
//    [dataTask resume];
    
    
    //  Old version of download
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *info = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (comptetion) {
                comptetion(info, nil);
            }
        });      
    });
}

@end
