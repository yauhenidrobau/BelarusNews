//
//  ShareManager.h
//  KinopoiskParserObj
//
//  Created by Admin on 1/5/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsEntity.h"

#warning - comment 
/*
 плохое название, обрати внимание, как эпл называет свои enum-ы.
 в твое случае должно быть что-то типа такого

 typedef enum {
    ShareServiceTypeFacebook,
     ShareServiceTypeTwitter
     ShareServiceTypeVK
     ShareServiceTypeOK
     ShareServiceTypeGooglePlus
 } ShareServiceType;

 
 */

typedef enum {
    VMFaceBookShare,
    VMTwitterShare,
    VMVkontakteShare,
    VMOdnokklShare,
    VMGooglePlusShare
}Services;

@interface ShareManager : NSObject

+(instancetype)sharedInstance;

#warning comment
/*
 если serviceID - это Services, то почему NSInteger
 AndEntity - с маленькой буквы
 */

-(NSString *)setSharedDataWithServiceID:(NSInteger)serviceID AndEntity:(NewsEntity*)entity;
@end
