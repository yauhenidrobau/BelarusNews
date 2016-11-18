//
//  DataManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^UpdateDataCallback)(NSError *error);

@interface DataManager : NSObject

+(DataManager *) sharedInstance;
-(void) updateDataWithURLString:(NSString *)urlString AndCallBack:(UpdateDataCallback)completionHandler;
@property(nonatomic, strong) NSMutableDictionary<NSString *,NSString *> *infoDict;
@end
