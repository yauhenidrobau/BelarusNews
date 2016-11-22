//
//  NewsTableView.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

typedef void (^UpdateDataCallback)(NSError *error);

@interface NewsTableView: UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


#warning почему это аутлеты паблик?
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *uiView;
@end