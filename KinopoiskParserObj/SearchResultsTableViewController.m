//
//  SearchResultsTableViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 25/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "SearchResultsTableViewController.h"

#import "NewsTableViewCell.h"
#import "NewsEntity.h"

@interface SearchResultsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NewsEntity *newsEntity = self.searchResults[indexPath.row];
    
    cell.titleLabel.text = newsEntity.titleFeed;
    cell.descriptionLabel.text = newsEntity.descriptionFeed;
//    if (newsEntity.urlImage) {
//        cell.imageNewsView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newsEntity.urlImage]]];
//    } else {
//        cell.imageNewsView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]]];
//    }
    return cell;
}



@end
