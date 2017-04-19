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

+(NSArray*)getCategoriesTitlesFromMenuArray:(NSArray*)array;
+(NSArray*)getCategoriesLinksFromMenuArray:(NSArray*)array;
+(NSArray*)getSubCategoriesFromMenuArray:(NSArray*)array;
+(NSArray*)getTitlesForRequestFromMenuArray:(NSArray*)array;

+(NSArray*)getAllCategories;

+(void)addShadowToView:(UIView*)view;

@end

@interface NSDateFormatter (Localized)

+ (NSDateFormatter *)currentLocalization;

@end
