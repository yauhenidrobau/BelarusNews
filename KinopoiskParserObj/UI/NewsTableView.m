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

typedef void(^UpdateDataCallback)(NSError *error);
typedef enum {
    AllCategoryType = 0,
    DevByCategoryType = 1,
    TutByCategoryType  = 2,
    MtsByCategoryType = 3
}CategoryTypes;

@interface NewsTableView () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchBarDelegate,NYSegmentedControlDataSource, LMSideBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet NYSegmentedControl *NewsSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) CGPoint lastContentOffset;
@property (strong, nonatomic) NSOperationQueue * operationQueue;
@property (strong, nonatomic) NSArray * urlArray;
@property (strong, nonatomic) NSArray * titlesArray;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property (strong, nonatomic) NSArray *newsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray<NewsEntity *> *searchResults;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL isAlertShown;
@property (nonatomic) BOOL isSearchStart;

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
    self.operationQueue = [NSOperationQueue new];
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

    [self.timer invalidate];
    self.timer = nil;
}

-(NSArray *)urlArray {
    if (!_urlArray.count) {
        switch(self.NewsSegmentedControl.selectedSegmentIndex) {
            case AllCategoryType:
                _urlArray = @[DEV_BY_NEWS,TUT_BY_NEWS,MTS_BY_NEWS];
                break;
            case DevByCategoryType:
                _urlArray = @[DEV_BY_NEWS];
                break;
            case TutByCategoryType:
                _urlArray = @[TUT_BY_NEWS];
                break;
            case MtsByCategoryType:
                _urlArray = @[MTS_BY_NEWS];
                break;
            default: nil;
                break;
        }
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
    __weak __typeof(self) wself = self;
    [UIView animateWithDuration:0.9 animations:^{
        [wself.tableView setContentOffset:CGPointZero animated:YES];
    }];
    self.scrollButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)changeValueSC {
//    if (isAllNewsLoaded) {
//        <#statements#>
//    }
    if (self.NewsSegmentedControl.selectedSegmentIndex != AllCategoryType) {
        [self updateDataWithIndicator:YES];
    } else {
        [self setupData];
    }
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchStart) {
        return self.searchResults.count? self.searchResults.count : 0;
    }

    return self.newsArray.count? self.newsArray.count : 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NewsTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NewsEntity *newsEntity = nil;
    if (self.isSearchStart) {
        newsEntity = self.searchResults.count? self.searchResults[indexPath.row] : self.newsArray[indexPath.row];
    } else {
        newsEntity = self.newsArray.count? self.newsArray[indexPath.row] : self.newsArray[indexPath.row];
    }
    [cell cellForNews:newsEntity AndTitles:self.titlesArray AndIndex:self.NewsSegmentedControl.selectedSegmentIndex];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.scrollButton.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:self.scrollButton.frame];
    view.alpha = 0;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailsVCID"]) {
        UITableViewCell *cell = (UITableViewCell*)sender;
        DetailsViewController *vc = segue.destinationViewController;
        NewsEntity *newsEntity = self.searchResults[[self.tableView indexPathForCell:cell].row]? self.searchResults[[self.tableView indexPathForCell:cell].row] : self.newsArray[[self.tableView indexPathForCell:cell].row];
        vc.newsUrl =[NSURL URLWithString:newsEntity.linkFeed];
        [vc.navigationItem setTitle:self.titlesArray[0]];
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
    NSString *text;
    if (self.isSearchStart) {
        text = @"";
    } else {
    text = NSLocalizedString(@"No Network", nil);
    }
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 2) {
        [self showLoadingIndicator:YES];
        self.isSearchStart = YES;
        __weak typeof (self)wself = self;
        [[SearchManager sharedInstance]updateSearchResults:self.searchBar.text forArray:self.newsArray withCompletion:^(NSArray *searchResults, NSError *error) {
            wself.searchResults = searchResults;
            [self showLoadingIndicator:NO];
            [wself.tableView reloadData];
        }];
    } else {
        self.isSearchStart = NO;
        [self setupData];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollButton.hidden = !(scrollView.contentOffset.y > 20);
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
    [self showLoadingIndicator:YES];
    if (self.NewsSegmentedControl.selectedSegmentIndex != AllCategoryType) {
        RLMResults *results = [NewsEntity objectsWhere:@"feedIdString == %@",self.titlesArray[0]];
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
    [self showLoadingIndicator:NO];

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
    
#warning неправильно. [[DataManager sharedInstance ] updateDataWithURLString - вот это ты должен вызывать в main потоке и возвращать даныне тоже в main. А внутри работать с фоновым потоком.
    dispatch_async(dispatch_get_main_queue(), ^{
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [self showAlertController];
//            [self setupData];
        }else {
            [networkReachability startNotifier];
            if(networkStatus == NotReachable) {
                [self showAlertController];
//                [self setupData];

            } else {
                __weak __typeof(self) wself = self;
                [self showLoadingIndicator:showIndicator];
                self.isAlertShown = NO;
                wself.urlArray = nil;
                wself.titlesArray = nil;
                [[DataManager sharedInstance ] updateDataWithURLArray:wself.urlArray  WithCallBack:^(NSError *error) {
                    [networkReachability stopNotifier];
                    if (!error) {
                        [self setupData];
                        if(showIndicator) {
                        [self showLoadingIndicator:!showIndicator];
                        }
                        [wself.refreshControl endRefreshing];
                        [wself.tableView reloadData];
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
