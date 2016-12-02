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

-(void)loadData:(NSString *)urlString callback:(DataLoadCallback)completion {
    // load data
#warning AFNetworking - очень рекомендую разобраться
    NSURL *URL = [NSURL URLWithString:urlString];
    __weak __typeof(self) wself = self;
   NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        wself.info = (NSData *)responseObject;
        if(completion) {
            completion(wself.info,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];

    //  Old version of download
    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 //       NSURL *url = [NSURL URLWithString:urlString];
  //      NSData *info = [NSData dataWithContentsOfURL:url];
   //     dispatch_async(dispatch_get_main_queue(), ^{
  //         if (comptetion) {
   //            comptetion(info, nil);
   //         }
  //      });
 //   });
}

@end
