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
#import <UIAlertController+Blocks.h>
#import <NYSegmentedControl.h>

#define YANDEX_NEWS @"https://st.kp.yandex.net/rss/news_premiers.rss"
#define TUT_BY_NEWS @"http://news.tut.by/rss/all.rss"
#define DEV_BY_NEWS @"https://dev.by/rss"

typedef void(^UpdateDataCallback)(NSError *error);

@interface NewsTableView () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchBarDelegate,NYSegmentedControlDataSource>

@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet NYSegmentedControl *NewsSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CGPoint lastContentOffset;
@property (strong, nonatomic) NSArray * urlArray;
@property (strong, nonatomic) NSArray * titlesArray;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property (strong, nonatomic) RLMResults<NewsEntity*> *newsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray<NewsEntity *> *searchResults;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation NewsTableView

#pragma mark - Lifecycle

-(void)viewDidLoad {

    [super viewDidLoad];
    [self setAppierance];
    [self updateDataWithIndicator:YES];
//    [self setupData];
    [self setupAppearanceNewsSegmentedControl];
    [self addPullToRefresh];

    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerActionRefresh) userInfo:nil repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

-(NSArray *)urlArray {
    if (!_urlArray.count) {
        _urlArray = [NSArray arrayWithObjects:DEV_BY_NEWS,TUT_BY_NEWS,YANDEX_NEWS, nil];
    }
    return _urlArray;
}

-(NSArray *)titlesArray {
    if (!_titlesArray.count) {
        _titlesArray = @[NSLocalizedString(@"DEV.BY", nil),NSLocalizedString(@"TUT.BY", nil),NSLocalizedString(@"MTS.BY", nil)];
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

-(IBAction)scrollButtonTouchUpInside:(id)sender {
    __weak typeof(self.tableView) weakTableView = self.tableView;
    [UIView animateWithDuration:0.9 animations:^{
        [weakTableView setContentOffset:CGPointZero animated:YES];
    }];
    self.scrollButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)changeValueSC {
    [self updateDataWithIndicator:YES];
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
    return YES;
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.newsArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NewsTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NewsEntity *newsEntity = self.newsArray[indexPath.row];
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
        NewsEntity *newsEntity = self.newsArray[[self.tableView indexPathForCell:cell].row];
        vc.newsUrl =[NSURL URLWithString:newsEntity.linkFeed];
        [vc.navigationItem setTitle:self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]];
    }
}
#pragma mark - NYSegmentedControlDataSource

- (NSUInteger) numberOfSegmentsOfControl:(NYSegmentedControl *)control {
    return self.titlesArray.count;
}
- (NSString *) segmentedControl:(NYSegmentedControl *)control titleAtIndex:(NSInteger)index {
    return self.titlesArray[index];
}


#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

#warning TODO not delete please
//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//   
//    NSString *searchString = self.searchController.searchBar.text;
//    [self updateFilteredContentForNewsTitle:searchString];
//    if (self.searchController.searchResultsController) {
//        UINavigationController *navigationVC = (UINavigationController *)self.searchController.searchResultsController;
//        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navigationVC.topViewController;
//        vc.searchResults = self.searchResults;
//        vc.titlesArray = self.titlesArray;
//        [vc.tableView reloadData];
//        
//    }
//}
//
//-(void)updateFilteredContentForNewsTitle:(NSString *)newsTitle {
//    if (!newsTitle) {
//        self.searchResults = [self.newsArray mutableCopy];
//    } else {
//        NSMutableArray *searchResults = [NSMutableArray new];
//        for (NSInteger i = 0;i < self.newsArray.count;i++) {
//            NewsEntity *entity = self.newsArray[i];
//            if ([entity.titleFeed containsString:newsTitle]) {
//                [searchResults addObject:entity];
//            }
//        }
//        self.searchResults = searchResults;
//    }
//}

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
    self.newsArray = [NewsEntity objectsWhere:@"feedIdString == %@",self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]];
    [self.tableView reloadData];
    if (!self.newsArray.count) {
        [self.tableView setScrollEnabled:NO];
        [self.activityInd stopAnimating];
        [self.refreshControl endRefreshing];
    }
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
#warning TODO NSLocalizedString
    [UIAlertController  showAlertInViewController:self
                                        withTitle:NSLocalizedString(@"We have problems",nil)
                                          message:NSLocalizedString(@"No Network :(",nil)
                                cancelButtonTitle:NSLocalizedString(@"OK",nil)
                           destructiveButtonTitle:nil
                                otherButtonTitles:nil
                                         tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                             [self showLoadingIndicator:NO];
                                             [self setupData];
                                         }];
}

-(void)updateDataWithIndicator:(BOOL)showIndicator {
    
#warning неправильно. [[DataManager sharedInstance ] updateDataWithURLString - вот это ты должен вызывать в main потоке и возвращать даныне тоже в main. А внутри работать с фоновым потоком.
    dispatch_async(dispatch_get_main_queue(), ^{
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [self showAlertController];
        }else {
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
            NetworkStatus status = [reachability currentReachabilityStatus];
            if(status == NotReachable) {
                [self showAlertController];
            } else {
                __weak typeof(self.refreshControl) weakRefreshControl = self.refreshControl;
                __weak typeof(self.tableView) weakTableView = self.tableView;
                [self showLoadingIndicator:showIndicator];

                [[DataManager sharedInstance ] updateDataWithURLString:self.urlArray[self.NewsSegmentedControl.selectedSegmentIndex] AndTitleString:self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex] WithCallBack:^(NSError *error) {
                    if (!error) {
                        [self setupData];
                        NSLog(@"GET ELEMENTS %ld",self.newsArray.count);
                        if(showIndicator) {
                        [self showLoadingIndicator:!showIndicator];
                        }
                        [weakRefreshControl endRefreshing];
                        [weakTableView reloadData];
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
