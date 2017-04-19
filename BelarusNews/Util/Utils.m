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

+(NSArray*)getCategoriesTitlesFromMenuArray:(NSArray *)array {
    NSMutableArray *titles = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        NSNumber *checked = dict[@"Checked"];
        if (checked.integerValue) {
            [titles addObject:dict[@"SourceName"]];
        }
    }
    return titles;
}

+(NSArray*)getCategoriesLinksFromMenuArray:(NSArray *)array {
    NSMutableArray *linkArray = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        NSNumber *checked = dict[@"Checked"];
        if (checked.integerValue) {
            [linkArray addObject:dict[@"link"]];
        }
    }
    
    return linkArray;
}

+(NSArray*)getSubCategoriesFromMenuArray:(NSArray *)array {
    NSMutableArray *subCategories = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        NSNumber *checked = dict[@"Checked"];
        if (checked.integerValue) {
            [subCategories addObject:dict[@"Categories"]];
        }
    }
    
    return subCategories;
}

+(NSArray*)getTitlesForRequestFromMenuArray:(NSArray *)array {
    NSMutableArray *titlesForRequest = [NSMutableArray new];
    NSDictionary *titles = @{@"ONLINER" :
                                 @[@"People",
                                   @"Auto",
                                   @"Science",
                                   @"Realty"],
                             @"TUT.BY" :
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
                             @"Новый-Час" :
                             @[@"All News"]};
    for (NSDictionary *dict in array) {
        NSNumber *checked = dict[@"Checked"];
        if (checked.integerValue) {
            [titlesForRequest addObject:titles[dict[@"SourceName"]]];
        }
    }
    
    return titlesForRequest;
}

+(NSArray*)getAllCategories {
    NSArray *categories = [NSArray arrayWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:ONLINER_BY,@"link",
                                                        @[NSLocalizedString(@"People",nil),
                                                        NSLocalizedString(@"Auto",nil),
                                                        NSLocalizedString(@"Science",nil),
                                                        NSLocalizedString(@"Realty",nil)],@"Categories",
                                                                     @(1),@"Checked",@"ONLINER",@"SourceName",nil],
                     
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
                                                          @(1),@"Checked",@"TUT.BY",@"SourceName", nil],
            
                                                        [NSMutableDictionary dictionaryWithObjectsAndKeys:DEV_BY,@"link",
                                                        @[NSLocalizedString(@"All News",nil)],@"Categories",
                                                          @(1),@"Checked",@"DEV.BY",@"SourceName",nil],
            
                                                        [NSMutableDictionary dictionaryWithObjectsAndKeys:S13_RU,@"link",
                                                         @[NSLocalizedString(@"All News",nil)],@"Categories",
                                                         @(1),@"Checked",@"S13",@"SourceName",nil],
            
                                                        [NSMutableDictionary dictionaryWithObjectsAndKeys:NOVYCHAS_BY,@"link",
                                                         @[NSLocalizedString(@"All News",nil)],@"Categories",
                                                         @(1),@"Checked",@"Новый-Час",@"SourceName",nil],
                                                        nil];

    return categories;
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
