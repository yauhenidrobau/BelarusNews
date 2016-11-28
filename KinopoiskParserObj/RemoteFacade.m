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
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        self.info = responseObject;
//        if (comptetion) {
//            comptetion(self.info, nil);
//        }
//    }];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
    
    // Make sure to set the responseSerializer correctly
    operation.requestSerializer = [AFHTTPRequestSerializer serializer];
    [operation.requestSerializer setValue:@"application/rss+xml" forHTTPHeaderField:@"content-type"];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    [operation setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
//    NSData *dataa = [operation responseData];
    [operation GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *dat = (NSData *)responseObject;
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving News"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

     
     //    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",errResponse);
////            NSLog(@"%@ %@", response, responseObject);
//        }
//    }];
//    [dataTask resume];
    
    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *url = [NSURL URLWithString:dataURL];
//        NSData *info = [NSData dataWithContentsOfURL:url];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (comptetion) {
//                comptetion(info, nil);
//            }
//        });      
//    });
}

@end
