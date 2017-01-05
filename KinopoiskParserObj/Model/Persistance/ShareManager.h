//
//  ShareManager.h
//  KinopoiskParserObj
//
//  Created by Admin on 1/5/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsEntity.h"

typedef enum {
    VMFaceBookShare,
    VMTwitterShare,
    VMVkontakteShare,
    VMOdnokklShare,
    VMGooglePlusShare
}Services;

@interface ShareManager : NSObject

+(instancetype)sharedInstance;
-(NSString *)setSharedDataWithServiceID:(NSInteger)serviceID AndEntity:(NewsEntity*)entity;
@end
