//
//  DataManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+(DataManager *) sharedInstance;
-(void) updateData;
@property(nonatomic, strong) NSMutableDictionary<NSString *,NSString *> *infoDict;
@end
