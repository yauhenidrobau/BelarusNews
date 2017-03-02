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
    ShareServiceTypeFacebook,
     ShareServiceTypeTwitter,
     ShareServiceTypeVK,
     ShareServiceTypeOK,
     ShareServiceTypeGooglePlus
 } ShareServiceType;

@interface ShareManager : NSObject

+(instancetype)sharedInstance;

-(NSString*)shareWithServiceID:(ShareServiceType)serviceID AndEntity:(NewsEntity *)entity;
@end
