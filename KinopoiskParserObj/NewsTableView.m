//
//  NewsTableView.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "NewsTableView.h"

#import <Realm/Realm.h>
#import "DataManager.h"
#import "NewsTableViewCell.h"
#import "DetailsViewController.h"
#import "NewsEntity.h"
#import <UIKit/UIKit.h>
#import <Reachability.h>

@interface NewsTableView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *NewsSegmentedControl;
@property (assign, nonatomic) CGPoint lastContentOffset;
@property (nonatomic,strong) NSArray * array;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;

- (IBAction)scrollButtonTouchUpInside:(id)sender;

@end

@implementation NewsTableView
@synthesize navigationBarHidden;

#pragma mark - Properties

RLMResults<NewsEntity*> *newsArray = nil;
UIRefreshControl *refreshControl = nil;

-(NSArray *)array {
    if (!_array) {
        _array = @[@"dev.by",@"tut.by",@"yandex"];
    }
    return _array;
}
#pragma mark - Lifecycle

-(void)initRealmArray{
    newsArray = [NewsEntity objectsWhere:@"feedIdString == %@",self.array[self.NewsSegmentedControl.selectedSegmentIndex]];
}
-(void)viewDidLoad {

    [super viewDidLoad];
    [self setAppierance];
    [self updateData];
    [self initRealmArray];
    [self addPullToRefresh];
    self.scrollButton.hidden = YES;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
//    self.scrollButton.layer.cornerRadius = [self.scrollButton frame].size.height / 2;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"Back"];
    [self.navigationController setHidesBarsOnSwipe:YES];
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefreshBtnTouch)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No News Found";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Make sure that you turn on network.";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_data"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return newsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NewsTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NewsEntity *newsEntity = newsArray[indexPath.row];

    cell.titleLabel.text = newsEntity.titleFeed;
    cell.descriptionLabel.text = newsEntity.descriptionFeed;
    if (newsEntity.urlImage.length != 0) {
        cell.imageNewsView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newsEntity.urlImage]]];
    } else {
        cell.imageNewsView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.array[self.NewsSegmentedControl.selectedSegmentIndex]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsEntity *newsEntity = newsArray[indexPath.row];
    DetailsViewController *vc = [DetailsViewController newInstance];
    vc.url = newsEntity.linkFeed;
    [vc.navigationItem setTitle:self.array[self.NewsSegmentedControl.selectedSegmentIndex]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.y > 50 )
    {
        self.scrollButton.hidden = NO;
    }
    else
    {
        self.scrollButton.hidden = YES;
        // Upward
    }

}

-(void)onRefreshBtnTouch {
    [self updateData];
}

- (IBAction)scrollButtonTouchUpInside:(id)sender {
    [UIView animateWithDuration:0.9 animations:^{
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }];
    self.scrollButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)changeValueSC:(id)sender {
    [self updateData];
}

#pragma mark - Private methods

-(void)addPullToRefresh{
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor colorWithRed:173/255.0 green:31/255.0 blue:45/255.0 alpha:1.0];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}
-(void)refreshContent{
    [self updateData];
}

-(void) setAppierance {
    // auto re-sizing cell
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
    [self.activityInd setHidden:YES];
}

-(void)updateData {
    [self.activityInd setHidden:NO];
    [self.activityInd startAnimating];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            [[DataManager sharedInstance ] updateDataWithURLString:self.array[self.NewsSegmentedControl.selectedSegmentIndex] AndCallBack:^(NSError *error) {
                if (error == nil) {
                    NSLog(@"GET ELEMENTS %ld",newsArray.count);
                    [self initRealmArray];
                    [self.activityInd stopAnimating];
                    [self.activityInd setHidden:YES];
                    [refreshControl endRefreshing];
                    [self.tableView reloadData];
                    
                    
                }
            }];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
}
@end
