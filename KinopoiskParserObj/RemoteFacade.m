//
//  RemoteFacade.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "RemoteFacade.h"

typedef void (^DataLoadCallback)(NSData *info, NSError* error);

@interface RemoteFacade ()

@property (nonatomic, copy) DataLoadCallback callback;
@property (nonatomic, strong) NSData *info;

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
        NSURL *url = [NSURL URLWithString:(NSString *)dataURL];
        NSData* info = [NSData dataWithContentsOfURL:
                        url];
        self.callback = comptetion;
        //[self performSelectorOnMainThread:@selector(fetchedData:)
                             //  withObject:data waitUntilDone:YES];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.callback(self.info,nil);
    
    });
    
   
    //SWIFT
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { ()->() in
        if NSURL *url = [NSURL  initWithString:(NSString *)URLString] ;
        if let url =  NSURL.init(string: dataURL) {
            let xmlData = NSData.init(contentsOfURL: url)
            dispatch_async(dispatch_get_main_queue(), {
                callback(result: .Success(items: xmlData))
                
                
            })
        }else {
            dispatch_async(dispatch_get_main_queue(), {
                callback(result: .UnexpectedError(error: NSError(domain: "UnexpectedErrorDomain", code: -666, userInfo: nil)))
            })
        }
    })
    */
}

@end
