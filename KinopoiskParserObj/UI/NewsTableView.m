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
#import "SearchManager.h"
#import <UIKit/UIKit.h>
#import <Reachability.h>
#import <UIAlertController+Blocks.h>
#import <NYSegmentedControl.h>
#import "UIViewController+LMSideBarController.h"


#define YANDEX_NEWS @"https://st.kp.yandex.net/rss/news_premiers.rss"
#define MTS_BY_NEWS @"http://www.mts.by/rss/"
#define TUT_BY_NEWS @"http://news.tut.by/rss/all.rss"
#define DEV_BY_NEWS @"https://dev.by/rss"


typedef void(^UpdateDataCallback)(NSError *error);
typedef enum {
    AllCategoryType = 0,
    DevByCategoryType = 1,
    TutByCategoryType  = 2,
    MtsByCategoryType = 3
}CategoryTypes;

@interface NewsTableView () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchBarDelegate,NYSegmentedControlDataSource, LMSideBarControllerDelegate, UISearchResultsUpdating,UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet NYSegmentedControl *NewsSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CGPoint lastContentOffset;
@property (strong, nonatomic) NSArray * urlArray;
@property (strong, nonatomic) NSArray * titlesArray;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property (strong, nonatomic) NSArray *newsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSOperationQueue *operaionQueue;
@property (nonatomic, strong) NSArray<NewsEntity *> *searchResults;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAlertShown;
@property (nonatomic, assign) BOOL isSearchStart;

@end

@implementation NewsTableView

#pragma mark - Lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAppierance];
    [self setupData];
    [self setupAppearanceNewsSegmentedControl];
    [self addPullToRefresh];
    self.isAlertShown = NO;
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.definesPresentationContext = YES;
    self.searchBarView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    
    self.operaionQueue = [NSOperationQueue new];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(timerActionRefresh) userInfo:nil repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateDataWithIndicator:YES];
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.searchController.isActive) {
        self.searchController.active = NO;
    }
    [self.timer invalidate];
    self.timer = nil;
}

-(NSArray *)urlArray {
    if (!_urlArray.count) {
        _urlArray = [NSArray arrayWithObjects:DEV_BY_NEWS,TUT_BY_NEWS,MTS_BY_NEWS, nil];
    }
    return _urlArray;
}

-(NSArray *)titlesArray {
    if (!_titlesArray.count) {
        switch(self.NewsSegmentedControl.selectedSegmentIndex) {
            case AllCategoryType:
                _titlesArray = @[@"",NSLocalizedString(@"DEV.BY", nil),NSLocalizedString(@"TUT.BY", nil),NSLocalizedString(@"MTS.BY", nil)];
            break;
            case DevByCategoryType:
                _titlesArray = @[ NSLocalizedString(@"DEV.BY", nil)];
                break;
            case TutByCategoryType:
                _titlesArray = @[NSLocalizedString(@"TUT.BY", nil)];
                break;
            case MtsByCategoryType:
                _titlesArray = @[NSLocalizedString(@"MTS.BY", nil)];
                break;
            default: nil;
                break;
        }
        
    }
    return _titlesArray;
}

#pragma mark - IBActions

-(void)onRefreshBtnTouch {
    [self updateDataWithIndicator:YES];
}

-(void)pullToRefresh {
    [self updateDataWithIndicator:NO];
}
- (IBAction)leftBarItemTouchUpInside:(id)sender {
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

-(IBAction)scrollButtonTouchUpInside:(id)sender {
    __weak __typeof(self)wself = self;
    [UIView animateWithDuration:0.9 animations:^{
        __strong typeof(self)wstrong = wself;

        [wstrong.tableView setContentOffset:CGPointZero animated:YES];
    }];
    self.scrollButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)changeValueSC {
    self.urlArray = nil;
    if (self.NewsSegmentedControl.selectedSegmentIndex != AllCategoryType) {
        [self updateDataWithIndicator:YES];
    } else {
        [self setupData];
    }
}

#pragma mark - DZNEmptyDataSetSource

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = NSLocalizedString(@"No News", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = NSLocalizedString(@"No Network", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_data"];
}

-(UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetSource Methods

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

-(BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchStart) {
        return self.searchResults.count;
    }

    return self.newsArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearchStart) {
        return self.searchResults.count? 1 : 0;
    }
    return self.newsArray.count? 1 : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NewsTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NewsEntity *newsEntity = self.searchResults.count? self.searchResults[indexPath.row] :self.newsArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell cellForNews:newsEntity AndTitles:self.titlesArray AndIndex:self.NewsSegmentedControl.selectedSegmentIndex];
    
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailsVCID"]) {
        UITableViewCell *cell = (UITableViewCell*)sender;
        DetailsViewController *vc = segue.destinationViewController;
        NewsEntity *newsEntity = self.searchResults[[self.tableView indexPathForCell:cell].row]? self.searchResults[[self.tableView indexPathForCell:cell].row] : self.newsArray[[self.tableView indexPathForCell:cell].row];
        vc.newsUrl =[NSURL URLWithString:newsEntity.linkFeed];
        [vc.navigationItem setTitle:self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]];
    }
}
#pragma mark - NYSegmentedControlDataSource

- (NSUInteger) numberOfSegmentsOfControl:(NYSegmentedControl *)control {
    return self.titlesArray.count;
}
- (NSString *) segmentedControl:(NYSegmentedControl *)control titleAtIndex:(NSInteger)index {
    switch(index) {
        case AllCategoryType:
            return @"All News";
            break;
        case DevByCategoryType:
            return @"DEV.BY";
            break;
        case TutByCategoryType:
            return @"TUT.BY";
            break;
        case MtsByCategoryType:
            return @"MTS.BY";
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0) {
    
//    NSString *textString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
//    self.isSearchStart = (textString.length);
    
    return YES;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollButton.hidden = !(scrollView.contentOffset.y > 20);
}

#pragma mark UISearchUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.operaionQueue cancelAllOperations];
    __weak typeof (self)wself = self;
    [self.operaionQueue addOperationWithBlock:^{
        __strong typeof (self)wstrong = wself;

        wstrong.searchResults = [[SearchManager sharedInstance]updateSearchResults:wstrong.searchController.searchBar.text forArray:wstrong.newsArray];
            [wstrong.tableView reloadData];
    }];
}

#pragma mark - Private methods

-(void)addPullToRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:173/255.0 green:31/255.0 blue:45/255.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

-(void)timerActionRefresh {
    [self updateDataWithIndicator:YES];
}
-(void)setAppierance {
    // auto re-sizing cell
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.activityInd setHidden:YES];
    self.scrollButton.hidden = YES;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.navigationController setHidesBarsOnSwipe:YES];
    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefreshBtnTouch)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
}

-(void)setupData{
    if (self.NewsSegmentedControl.selectedSegmentIndex != AllCategoryType) {
        RLMResults *results = [NewsEntity objectsWhere:@"feedIdString == %@",self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]];
        NSArray *resultsArray = [self RLMResultsToArray:results];
        
        self.newsArray = [self sortNewsArray:resultsArray];
        NSLog(@"Get ELEMENTS  %lu",(unsigned long)self.newsArray.count);
    } else {
        RLMResults *allResults = [NewsEntity allObjects];
        NSArray *allResultsArray = [self RLMResultsToArray:allResults];

        self.newsArray = [self sortNewsArray:allResultsArray];
        NSLog(@"Get ELEMENTS  %lu",(unsigned long)self.newsArray.count);
    }
    [self.tableView reloadData];
    if (!self.newsArray.count) {
        [self.tableView setScrollEnabled:NO];
        [self.activityInd stopAnimating];
        [self.refreshControl endRefreshing];
    }
}


-(NSArray *)sortNewsArray:(NSArray*)newsArray {
    NSSortDescriptor * newSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDateFeed" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:newSortDescriptor];
    self.newsArray = [newsArray sortedArrayUsingDescriptors:sortDescriptors];
    return self.newsArray;
}

-(NSArray*)RLMResultsToArray:(RLMResults *)results{
    NSMutableArray *array = [NSMutableArray array];
    for (RLMObject *object in results) {
        [array addObject:object];
    }
    return array;
}
-(void)showLoadingIndicator:(BOOL)show {
    self.activityInd.hidden = !show;
    if (show) {
        [self.activityInd startAnimating];
    }else {
        [self.activityInd stopAnimating];
    }
}

-(void)showAlertController {
    if (!self.isAlertShown) {
        [self showLoadingIndicator:YES];
        [UIAlertController  showAlertInViewController:self
                                            withTitle:NSLocalizedString(@"We have problems", nil)
                                              message:NSLocalizedString(@"No Network",nil)
                                    cancelButtonTitle:NSLocalizedString(@"OK",nil)
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil
                                             tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                 [self setupData];
                                                 [self showLoadingIndicator:NO];
                                             }];
        self.isAlertShown = YES;
    }
}

-(void)updateDataWithIndicator:(BOOL)showIndicator {
    
    __weak typeof(self)wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self)wstrong = wself;
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [wstrong showAlertController];
            [wstrong setupData];
        }else {
            [networkReachability startNotifier];
            if(networkStatus == NotReachable) {
                [wstrong showAlertController];
                [wstrong setupData];

            } else {
                [wstrong showLoadingIndicator:showIndicator];
                wstrong.isAlertShown = NO;
                __weak typeof(self)wself = wstrong;

                [[DataManager sharedInstance] updateDataWithURLArray:wstrong.urlArray AndTitleArray:wstrong.titlesArray WithCallBack:^(NSError *error) {
                    __strong typeof(self)wstrong = wself;

                    [networkReachability stopNotifier];
                    if (!error) {
                        [wstrong setupData];
//                        NSLog(@"GET ELEMENTS %ld",self.newsArray.count);
                        if(showIndicator) {
                        [wstrong showLoadingIndicator:!showIndicator];
                        }
                        [wstrong.refreshControl endRefreshing];
                        [wstrong.tableView reloadData];
                    }
                }];
            }
        }
    });
}

-(void)setupAppearanceNewsSegmentedControl {
    [self.NewsSegmentedControl layoutIfNeeded];
    UIColor *mainColor = [UIColor colorWithRed:253. / 255. green:253. /255. blue:253. / 255. alpha:1.0];
    self.NewsSegmentedControl.borderWidth = 0.5f;
    self.NewsSegmentedControl.borderColor = [UIColor colorWithWhite:227./255. alpha:1.0f];
    self.NewsSegmentedControl.backgroundColor = [UIColor colorWithRed:235./255. green:236./255. blue:239./255. alpha:1.0f];
//    self.NewsSegmentedControl.layer.cornerRadius = self.NewsSegmentedControl.frame.size.height / 2;
    self.NewsSegmentedControl.cornerRadius = self.NewsSegmentedControl.frame.size.height / 2;
    self.NewsSegmentedControl.drawsGradientBackground = NO;
    self.NewsSegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.NewsSegmentedControl.segmentIndicatorGradientTopColor = mainColor;
    self.NewsSegmentedControl.segmentIndicatorGradientBottomColor = mainColor;
    self.NewsSegmentedControl.segmentIndicatorAnimationDuration = 0.3f;
    self.NewsSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.NewsSegmentedControl.selectedTitleTextColor = [UIColor colorWithRed:9. / 255. green:171. /255. blue:225. / 255. alpha:1.0];
    self.NewsSegmentedControl.titleTextColor = [UIColor colorWithRed:98. / 255. green:128. /255. blue:142. / 255. alpha:1.0];
    self.NewsSegmentedControl.dataSource = self;
    [self.NewsSegmentedControl addTarget:self action:@selector(changeValueSC) forControlEvents:UIControlEventValueChanged];
}
@end
