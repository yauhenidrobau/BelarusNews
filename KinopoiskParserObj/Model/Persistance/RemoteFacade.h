//
//  RemoteFacade.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataLoadCallback)(NSData * info,NSString *feedIdString, NSError* error);

@interface RemoteFacade : NSObject

+(instancetype)sharedInstance;
-(void)loadData:(NSArray *)urlArrayL callback:(DataLoadCallback)comptetion;

@end
