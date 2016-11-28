//
//  SearchResultsTableViewController.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 25/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEntity.h"
#import "NewsTableView.h"

@interface SearchResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<NewsEntity *> *searchResults;
@property (strong, nonatomic) NSArray * titlesArray;

@end
