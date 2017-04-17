//
//  Utils.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 09/01/2017.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "Utils.h"

#import "DateFormatterManager.h"
#import <UIKit/UIKit.h>
#import "UserDefaultsManager.h"
#import "UIColor+BelarusNews.h"
#import "Constants.h"

@implementation Utils

+(NewsTableView*)getMainController {
    
    NewsTableView *newsTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsTableView"];
    newsTableViewController.urlString = [[UserDefaultsManager sharedInstance] objectForKey:@"CurrentUrl"];
    newsTableViewController.categoryString = [[UserDefaultsManager sharedInstance] objectForKey:@"CurrentTitle"];
    
    return newsTableViewController;
}

+(void)setNightNavigationBar:(UINavigationBar*)navBar {
    [navBar setBarTintColor:[UIColor bn_navBarNightColor]];
    [navBar setTintColor:[UIColor bn_navBarNightTitleColor]];
    [navBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor bn_navBarNightTitleColor]}];
}

+(void)setDefaultNavigationBar:(UINavigationBar*)navBar {
    [navBar setBarTintColor:[UIColor bn_settingsBackgroundColor]];
    [navBar setTintColor:[UIColor bn_navBarTitleColor]];
    [navBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor bn_navBarTitleColor]}];
}

+(void)setNavigationBar:(UINavigationBar*)bar light:(BOOL)light {
    if (!light) {
        bar.barStyle = UIStatusBarStyleDefault;
    } else {
        bar.barStyle = UIStatusBarStyleLightContent;
    }
}

+(NSArray*)getCategoriesTitlesFromDictionary:(NSDictionary *)dict {
    NSMutableArray *titles = [NSMutableArray new];
    for (NSString *key in dict) {
        NSNumber *checked = dict[key][@"Checked"];
        if (checked.integerValue) {
            [titles addObject:key];
        }
    }
    return titles;
}

+(NSArray*)getCategoriesLinksFromDictionary:(NSDictionary*)dict {
    NSMutableArray *linkArray = [NSMutableArray new];
    for (NSString *key in dict) {
        NSNumber *checked = dict[key][@"Checked"];
        if (checked.integerValue) {
            [linkArray addObject:dict[key][@"link"]];
        }
    }
    return linkArray;
}

+(NSArray*)getSubCategoriesFromDictionary:(NSDictionary*)dict {
    NSMutableArray *subCategories = [NSMutableArray new];
    for (NSString *key in dict) {
        NSNumber *checked = dict[key][@"Checked"];
        if (checked.integerValue) {
            [subCategories addObject:dict[key][@"Categories"]];
        }
    }
    return subCategories;
}

+(NSArray*)getTitlesForRequestFromDictionary:(NSDictionary*)dict {
    NSMutableArray *titlesForRequest = [NSMutableArray new];
    NSDictionary *titles = @{@"TUT.BY" :
                             @[@"Main",
                               @"Economic",
                               @"Society",
                               @"World",
                               @"Culture",
                               @"Accident",
                               @"Finance",
                               @"Realty",
                               @"Sport",
                               @"Auto",
                               @"Lady",
                               @"Science"],
                             @"DEV.BY" :
                             @[@"All News"],
                             @"S13" :
                             @[@"All News"],
                             @"ONLINER" :
                             @[@"People",
                               @"Auto",
                               @"Science",
                               @"Realty"],
                             @"Новый-Час" :
                             @[@"All News"]};
    for (NSString *key in dict) {
        NSNumber *checked = dict[key][@"Checked"];
        if (checked.integerValue) {
            [titlesForRequest addObject:titles[key]];
        }
    }
    return titlesForRequest;
}

+(NSDictionary*)getAllCategories {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionaryWithObjectsAndKeys:ONLINER_BY,@"link",
                                                        @[NSLocalizedString(@"People",nil),
                                                        NSLocalizedString(@"Auto",nil),
                                                        NSLocalizedString(@"Science",nil),
                                                        NSLocalizedString(@"Realty",nil)],@"Categories",
                                                       @(1),@"Checked",nil],
                                                        @"ONLINER",
            
                                                        [NSMutableDictionary dictionaryWithObjectsAndKeys:TUT_BY,@"link",
                                                        @[NSLocalizedString(@"Main",nil),
                                                          NSLocalizedString(@"Economic",nil),
                                                          NSLocalizedString(@"Society",nil),
                                                          NSLocalizedString(@"World",nil),
                                                          NSLocalizedString(@"Culture",nil),
                                                          NSLocalizedString(@"Accident",nil),
                                                          NSLocalizedString(@"Finance",nil),
                                                          NSLocalizedString(@"Realty",nil),
                                                          NSLocalizedString(@"Sport",nil),
                                                          NSLocalizedString(@"Auto",nil),
                                                          NSLocalizedString(@"Lady",nil),
                                                          NSLocalizedString(@"Science",nil)],@"Categories",
                                                          @(1),@"Checked", nil],
                                                        @"TUT.BY",
            
                                                        [NSMutableDictionary dictionaryWithObjectsAndKeys:DEV_BY,@"link",
                                                        @[NSLocalizedString(@"All News",nil)],@"Categories",
                                                          @(1),@"Checked",nil],
                                                        @"DEV.BY",
            
                                                        [NSMutableDictionary dictionaryWithObjectsAndKeys:S13_RU,@"link",
                                                         @[NSLocalizedString(@"All News",nil)],@"Categories",
                                                         @(1),@"Checked",nil],
                                                        @"S13",
            
                                                        [NSMutableDictionary dictionaryWithObjectsAndKeys:NOVYCHAS_BY,@"link",
                                                         @[NSLocalizedString(@"All News",nil)],@"Categories",
                                                         @(1),@"Checked",nil],
                                                        @"Новый-Час",nil];
}

+(void)addShadowToView:(UIView*)view {
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end

@implementation NSDateFormatter (Localized)

+ (NSDateFormatter *)currentLocalization {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[DateFormatterManager sharedInstance] currentLocale];
    return dateFormatter;
}

@end
