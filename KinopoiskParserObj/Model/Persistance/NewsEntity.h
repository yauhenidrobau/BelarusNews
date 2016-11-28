//
//  NewsEntity.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 17/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Realm/Realm.h>

@interface NewsEntity : RLMObject
@property  NSString *feedIdString;
@property  NSString *descriptionFeed;
@property  NSString *linkFeed;
@property  NSString *pubDateFeed;
@property  NSString *titleFeed;
@property  NSString *urlImage;

@end

RLM_ARRAY_TYPE(NewsEntity)
