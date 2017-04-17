//
//  Utils.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 09/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsTableView.h"

@interface Utils : NSObject

+(NewsTableView*)getMainController;
+(void)setNightNavigationBar:(UINavigationBar*)navBar;
+(void)setDefaultNavigationBar:(UINavigationBar*)navBar;
+(void)setNavigationBar:(UINavigationBar*)bar light:(BOOL)light;

+(NSArray*)getCategoriesTitlesFromDictionary:(NSDictionary*)dict;
+(NSArray*)getCategoriesLinksFromDictionary:(NSDictionary*)dict;
+(NSArray*)getSubCategoriesFromDictionary:(NSDictionary*)dict;
+(NSArray*)getTitlesForRequestFromDictionary:(NSDictionary*)dict;

+(NSDictionary*)getAllCategories;

+(void)addShadowToView:(UIView*)view;

@end

@interface NSDateFormatter (Localized)

+ (NSDateFormatter *)currentLocalization;

@end
