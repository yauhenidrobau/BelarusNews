//
//  NewsTableView.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "NewsTableView.h"

#import <Realm/Realm.h>
#import <Reachability.h>
#import <AFNetworking.h>
#import <UIAlertController+Blocks.h>
#import "UIViewController+LMSideBarController.h"
#import "Constants.h"
#import "Macros.h"

#import "DataManager.h"
#import "SearchManager.h"
#import "RealmDataManager.h"
#import "ShareManager.h"
#import "NewsEntity.h"
#import "UserDefaultsManager.h"

#import "NewsTableViewCell.h"
#import "DetailsViewController.h"
#import "DetailsOfflineVCViewController.h"

#import "INSSearchBar.h"
#import <CFShareCircleView.h>
#import "Masonry.h"
#import "ZLDropDownMenuUICalc.h"
#import "ZLDropDownMenuCollectionViewCell.h"
#import "ZLDropDownMenu.h"
#import "NSString+ZLStringSize.h"

#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"
#import "Utils.h"

#import <Google/Analytics.h>

typedef void(^UpdateDataCallback)(NSError *error);
typedef enum {
    AllCategoryType = 0,
    DevByCategoryType = 1,
    TutByCategoryType  = 2,
    MtsByCategoryType = 3
}CategoryTypes;


@interface NewsTableView () <UIScrollViewDelegate, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,LMSideBarControllerDelegate, ZLDropDownMenuDelegate, ZLDropDownMenuDataSource,INSSearchBarDelegate, NewsTableViewCellDelegate,CFShareCircleViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) INSSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CFShareCircleView *shareCircleView;
@property (nonatomic, strong) UserDefaultsManager *userDefaults;
@property (nonatomic) CGPoint lastContentOffset;
@property (strong, nonatomic) NSOperationQueue * operationQueue;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *weatherTimer;

@property (nonatomic, strong) NSArray<NewsEntity *> *searchResults;
@property (strong, nonatomic) NSArray *newsArray;
@property (nonatomic, strong) NSArray *mainTitleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (nonatomic, strong) NSArray *titlesForRequestArray;
@property (nonatomic, strong) NSMutableDictionary *shareItemsDict;

@property (strong, nonatomic) NSDictionary *newsURLDict;

@property (nonatomic) BOOL isAlertShown;
@property (nonatomic) BOOL isSearchStart;
@property (nonatomic) BOOL isOfflineMode;
@property (nonatomic) BOOL isNightMode;

@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton;

@end

@implementation NewsTableView

#pragma mark - Lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    [self peparePullToRefresh];
    [self setupData];
    [self updateWithIndicator:YES];

    self.userDefaults = [UserDefaultsManager sharedInstance];
    self.operationQueue = [NSOperationQueue new];
    self.isAlertShown = [self.userDefaults boolForKey:NO_INTERNET_KEY];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.userDefaults boolForKey:AUTOUPDATE_MODE]) {
         self.timer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(timerActionRefresh) userInfo:nil repeats:YES];
        NSLog(@"Autoupdates enabled");
    } else {
        NSLog(@"Autoupdates disabled");
    }
    self.isOfflineMode = [self.userDefaults boolForKey:OFFLINE_MODE];
    self.isNightMode = [self.userDefaults boolForKey:NIGHT_MODE];
    [self setupData];
    [self prepareAppierance];
    self.weatherTimer = [NSTimer scheduledTimerWithTimeInterval:30 * 60 target:self selector:@selector(updateWeatherData) userInfo:nil repeats:YES];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - IBActions

-(void)onRefreshBtnTouch {
    [self updateWithIndicator:YES];
}

-(void)pullToRefresh {
    [self updateWithIndicator:NO];
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
    cell.cellDelegate = self;
    NewsEntity *newsEntity = nil;
    newsEntity = [self setNewsEntityForIndexPath:indexPath];
    [cell cellForNews:newsEntity WithIndexPath:(NSIndexPath *)indexPath];
    if (self.isNightMode) {
        [cell updateNightModeCell:YES];
    } else {
        [cell updateNightModeCell:NO];
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:self.scrollButton.frame];
    view.alpha = 0;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.alpha = 0;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* segueId = (![[Reachability reachabilityWithHostName:TEST_HOST] isReachable] || self.isOfflineMode) ? @"DetailsOfflineVCID" : @"DetailsVCID";
    NewsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:segueId sender:cell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NewsTableViewCell *cell = (NewsTableViewCell*)sender;
    NewsEntity *newsEntity = [self setNewsEntityForIndexPath:[self.tableView indexPathForCell:cell]];
    if ([segue.identifier isEqualToString:@"DetailsVCID"]) {
        DetailsViewController *vc = segue.destinationViewController;
        vc.sourceLink = [NSString stringWithString:newsEntity.linkFeed];
    } else if ([segue.identifier isEqualToString:@"DetailsOfflineVCID"]) {
        DetailsOfflineVCViewController *vc = segue.destinationViewController;
        if ([self.titlesString isEqualToString:@"S13"]) {
            vc.sourceLink = S13_RU;
        } else if ([self.titlesString isEqualToString:@"Новый-Час"]) {
            vc.sourceLink = NOVYCHAS_BY;
        } else if ([self.urlString containsString:@"onliner"]) {
            vc.sourceLink = ONLINER_BY;
        } else if ([self.urlString containsString:@"tut.by"]) {
            vc.sourceLink = TUT_BY;
        } else if ([self.titlesString isEqualToString:@"DEV.BY"]) {
            vc.sourceLink = DEV_BY;
        }
        vc.entity = newsEntity;
    } else if ([segue.identifier isEqualToString:@"ShareVCID"]) {
        DetailsViewController *vc = segue.destinationViewController;
        vc.sourceLink = self.shareItemsDict[@"authLink"];
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
    if (self.isSearchStart || self.menuTitle.length) {
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

#pragma mark - ZLDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(ZLDropDownMenu *)menu {
    return self.mainTitleArray.count;
}

- (NSInteger)menu:(ZLDropDownMenu *)menu numberOfRowsInColumns:(NSInteger)column {
    
    return ((NSArray*)self.subTitleArray[column]).count;
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForColumn:(NSInteger)column {
    return self.mainTitleArray[column];
}

- (NSString *)menu:(ZLDropDownMenu *)menu titleForRowAtIndexPath:(ZLIndexPath *)indexPath {
    NSArray *array = self.subTitleArray[indexPath.column];
    if (array.count) {
       return array[indexPath.row];
    } else
    return @"";
}

#pragma mark - ZLDropDownMenuDelegate
- (void)menu:(ZLDropDownMenu *)menu didSelectRowAtIndexPath:(ZLIndexPath *)indexPath {
    self.menuTitle = @"";
    self.isSearchStart = NO;

    NSArray *array = self.titlesForRequestArray[indexPath.column];
    if (array.count == 1) {
        self.titlesString = self.mainTitleArray[indexPath.column];
        self.urlString = self.newsURLDict[self.titlesString][0];
    } else {
    self.titlesString = array[indexPath.row];
    NSDictionary *dict = self.newsURLDict[self.mainTitleArray[indexPath.column]];
    self.urlString = dict[NSLocalizedString(self.titlesString,nil)];
    }
    NSLog(@"%@ : %@", self.titlesString,self.urlString);
    [self.userDefaults setObject:self.titlesString forKey:@"CurrentTitle"];
    [self.userDefaults setObject:self.urlString forKey:@"CurrentUrl"];
    [self updateWithIndicator:YES];
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:self.titlesString];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"News Category"
                                                          action:@"Visited"
                                                           label:self.titlesString
                                                           value:@1] build]];
    
}

#pragma mark - INSSearchBarDelegate

//- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar {
//    return CGRectMake(10, 5.0, CGRectGetWidth(self.view.bounds) - 20.0, 38.0);
//}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState {
    if (destinationState == INSSearchBarStateSearchBarVisible) {
        searchBar.searchField.tintColor = [UIColor blackColor];
    }
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState {
    searchBar.searchField.placeholder = NSLocalizedString(@"Search for news...", nil);
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar {
    [self searchBarTextDidChange:searchBar];
    [self.searchBar.searchField resignFirstResponder];
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar {
    NSString *searchText = searchBar.searchField.text;
    if (searchText.length > 2) {
        [self showLoadingIndicator:YES];
        self.isSearchStart = YES;
        self.newsArray = [[RealmDataManager sharedInstance] getAllOjbects];
        __weak typeof (self)wself = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [[SearchManager sharedInstance]updateSearchResults:wself.searchBar.searchField.text forArray:wself.newsArray withCompletion:^(NSArray *searchResults, NSError *error) {

                wself.searchResults = searchResults;
                [wself.tableView reloadData];
                [wself showLoadingIndicator:NO];

                NSLog(@"Get FROM SEARCH %ld",(unsigned long)wself.searchResults.count);
            }];
        });
    } else {
        self.isSearchStart = NO;
        [self setupData];
        NSLog(@"Get from DataBase");
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollButton.hidden = !(scrollView.contentOffset.y > 20);
    UITapGestureRecognizer *gestureRecognizer = [UITapGestureRecognizer new];
    [self.searchBar hideSearchBar:gestureRecognizer];

}

#pragma mark - NewsTableViewCellDelegate

- (void)newsTableViewCell:(NewsTableViewCell*)cell didTapFavoriteButton:(UIButton*)button {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    NewsEntity *entity = [self setNewsEntityForIndexPath:indexPath];
    [[RealmDataManager sharedInstance]updateEntity:entity WithProperty:@"favorite"];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)newsTableViewCell:(NewsTableViewCell*)cell didTapShareButton:(UIButton*)button {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    NewsEntity *entity = [self setNewsEntityForIndexPath:indexPath];
    self.shareItemsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:entity,@"entity", nil];
    [self.shareCircleView showAnimated:YES];
   
    [[RealmDataManager sharedInstance] updateEntity:entity WithProperty:@"isShare"];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark - CFShareCircleViewDelegate

- (void)shareCircleView:(CFShareCircleView *)shareCircleView didSelectSharer:(CFSharer *)sharer {
    if (self.shareItemsDict[@"authLink"]) {
        [self.shareItemsDict removeObjectForKey:@"authLink"];
    }
    [self.shareItemsDict setObject:[[ShareManager sharedInstance]shareWithServiceID:(ShareServiceType)sharer.serviceID AndEntity:self.shareItemsDict[@"entity"]]forKey:@"authLink"];
    [self performSegueWithIdentifier:@"ShareVCID" sender:self];
    NSLog(@"Selected sharer: %@", sharer.name);
}

- (void)shareCircleCanceled:(NSNotification *)notification{
    NSLog(@"Share circle view was canceled.");
}

#pragma mark - Private methods

-(void)peparePullToRefresh {
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:self.view.frame];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.refreshControl];
}

-(void)timerActionRefresh {
    [self updateWithIndicator:YES];
}

-(void)prepareAppierance {
    
    [self prepareTableView];
    [self prepareSearchBar];
    [self prepareNavigationBar];
    [self prepareDropMenu];
    [self prepareShareView];
    
    [self.activityInd setHidden:YES];
    self.scrollButton.hidden = YES;
    [self.scrollButton layoutIfNeeded];
    self.scrollButton.layer.cornerRadius = self.scrollButton.frame.size.height / 2;
    self.scrollButton.imageView.image = [self.scrollButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (self.isNightMode) {
        [self.scrollButton setTintColor:MAIN_COLOR];
        [Utils setNightNavigationBar:self.navigationController.navigationBar];
        self.refreshControl.tintColor = MAIN_COLOR;
        [self.backgroundImage setImage:[UIImage imageNamed:@"black_blur"]];
    } else {
        [self.scrollButton setTintColor:[UIColor bn_navBarColor]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.refreshControl.tintColor = [UIColor bn_navBarColor];
        [self.backgroundImage setImage:[UIImage imageNamed:@"main_blur"]];
    }
    self.leftMenuButton.imageView.image = [self.leftMenuButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.leftMenuButton setTintColor:[UIColor whiteColor]];
}

-(void)setupData {
    
    if (!self.menuTitle.length) {
        RLMResults *results = [NewsEntity objectsWhere:@"feedIdString == %@",self.titlesString];
        NSArray *allResultsArray = [[RealmDataManager sharedInstance] RLMResultsToArray:results];
        
        self.newsArray = [self sortNewsArray:allResultsArray];
        NSLog(@"Get ELEMENTS  %lu",(unsigned long)self.newsArray.count);
    } else if ([self.menuTitle isEqualToString:NSLocalizedString(@"Favorites", nil)]){
        self.menuTitle = @"";
        [self.userDefaults removeObjectForKey:@"menuTitle"];
        self.newsArray = [self sortNewsArray:[NSArray arrayWithArray:[[RealmDataManager sharedInstance] getFavoritesArray]]];
        NSLog(@"Get favorites Elements  %lu",(unsigned long)self.newsArray.count);
    }
   
    [self.tableView reloadData];
    [self showLoadingIndicator:NO];
    [self.refreshControl endRefreshing];

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

-(void)showLoadingIndicator:(BOOL)show {
    self.activityInd.hidden = !show;
    if (show) {
        [self.activityInd startAnimating];
    }else {
        [self.activityInd stopAnimating];
        [self.refreshControl endRefreshing];
    }
}

-(void)showAlertController {
        __weak typeof(self) wself = self;
        [UIAlertController  showAlertInViewController:self
                                            withTitle:NSLocalizedString(@"We have problems", nil)
                                              message:NSLocalizedString(@"No Network",nil)
                                    cancelButtonTitle:NSLocalizedString(@"OK",nil)
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil
                                             tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                 [wself setupData];
                                                 [wself showLoadingIndicator:NO];
                                             }];
}

-(void)updateWithIndicator:(BOOL)showIndicator {
    [self showLoadingIndicator:showIndicator];
    if (self.isOfflineMode) {
        [self setupData];
    } else {
        [self updateDataWithIndicator:showIndicator];
    }
    
}

-(void)updateDataWithIndicator:(BOOL)showIndicator {

    dispatch_async(dispatch_get_main_queue(), ^{

        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
       self.isAlertShown = [[UserDefaultsManager sharedInstance] boolForKey:NO_INTERNET_KEY];
        if (networkStatus == NotReachable && !self.isAlertShown) {
            [self showAlertController];
            [self.userDefaults setBool:YES ForKey:NO_INTERNET_KEY];
        }else {
            [networkReachability startNotifier];
            if(networkStatus == NotReachable && !self.isAlertShown) {
                [self showAlertController];
                [self.userDefaults setBool:YES ForKey:NO_INTERNET_KEY];
            } else {
                __weak typeof(self) wself = self;
                [[DataManager sharedInstance ] updateDataWithURLString:wself.urlString AndTitle:wself.titlesString WithCallBack:^(NSError *error) {
                    [networkReachability stopNotifier];
                    if (!error) {
                        [wself setupData];
                        if(showIndicator) {
                        [wself showLoadingIndicator:!showIndicator];
                        }
                    }
                }];
            }
        }
    });
}

-(NewsEntity *)setNewsEntityForIndexPath:(NSIndexPath*)indexPath {
    NewsEntity *newsEntity = nil;
    if (self.isSearchStart) {
        newsEntity = self.searchResults.count > indexPath.row ? self.searchResults[indexPath.row] : self.newsArray[indexPath.row];
    } else {
        newsEntity = self.newsArray.count ? self.newsArray[indexPath.row] : self.newsArray[indexPath.row];
    } 
    return newsEntity;
}

-(void)prepareTableView {
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

-(void)prepareNavigationBar {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [Utils setNavigationBar:self.navigationController.navigationBar light:YES];
}

-(void)prepareSearchBar {
    self.searchBar = [[INSSearchBar alloc] initWithFrame:CGRectMake(20.0, 5.0, CGRectGetWidth(self.view.bounds) - 40.0, 35)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.navigationItem.titleView = self.searchBar;
}

-(void)prepareData {
    _mainTitleArray = @[@"ONLINER",@"TUT.BY",@"DEV.BY", @"S13", @"Новый-Час"];
    _subTitleArray = @[
                       @[NSLocalizedString(@"People",nil),
                         NSLocalizedString(@"Auto",nil),
                         NSLocalizedString(@"Science",nil),
                         NSLocalizedString(@"Realty",nil)],
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
                         NSLocalizedString(@"Science",nil)],
                       @[NSLocalizedString(@"All News",nil)],
                       @[NSLocalizedString(@"All News",nil)],
                       @[NSLocalizedString(@"All News",nil)]
                       ];
    _titlesForRequestArray = @[
                       @[@"People",
                         @"Auto",
                         @"Science",
                         @"Realty"],
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
                       @[@"All News"],
                       @[@"All News"],
                       @[@"All News"]];
    self.newsURLDict = @{@"DEV.BY": @[DEV_BY_NEWS],
                         @"TUT.BY": [NSDictionary dictionaryWithObjectsAndKeys:
                                     MAIN_NEWS,NSLocalizedString(@"Main",nil),
                                     ECONOMIC_NEWS,NSLocalizedString(@"Economic",nil),
                                     SOCIETY_NEWS,NSLocalizedString(@"Society",nil),
                                     WORLD_NEWS,NSLocalizedString(@"World",nil),
                                     CULTURE_NEWS,NSLocalizedString(@"Culture",nil),
                                     ACCIDENT_NEWS,NSLocalizedString(@"Accident",nil),
                                     FINANCE_NEWS,NSLocalizedString(@"Finance",nil),
                                     REALTY_NEWS,NSLocalizedString(@"Realty",nil),
                                     SPORT_NEWS,NSLocalizedString(@"Sport",nil),
                                     AUTO_NEWS,NSLocalizedString(@"Auto",nil),
                                     LADY_NEWS,NSLocalizedString(@"Lady",nil),
                                     SCIENCE_NEWS,NSLocalizedString(@"Science",nil), nil],
                         @"ONLINER": [NSDictionary dictionaryWithObjectsAndKeys:
                                         PEOPLE_ONLINER_LINK,NSLocalizedString(@"People",nil),
                                         AUTO_ONLINER_LINK,NSLocalizedString(@"Auto",nil),TECH_ONLINER_NEWS,NSLocalizedString(@"Science",nil),REALT_ONLINER_NEWS,NSLocalizedString(@"Realty",nil), nil],
                         @"Новый-Час" : @[NOVY_CHAS_NEWS],
                        @"S13" : @[S13_NEWS]};
    self.titlesString = self.titlesForRequestArray[0][0];
    self.urlString = PEOPLE_ONLINER_LINK;
    [self.userDefaults setObject:self.titlesString forKey:@"CurrentTitle"];
    [self.userDefaults setObject:self.urlString forKey:@"CurrentUrl"];
    self.shareItemsDict = [NSMutableDictionary new];
}

-(void)prepareDropMenu {
    for (ZLDropDownMenu * menu in self.menuView.subviews) {
        [menu removeFromSuperview];
    }
    ZLDropDownMenu *menu = [[ZLDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, deviceWidth(), 43)];
    menu.isNightMode = self.isNightMode;
    if (self.isNightMode) {
        menu.customBackgroundColor = [UIColor bn_nightModeBackgroundColor];
        menu.collectionViewColor = [UIColor bn_nightModeBackgroundColor];
    } else {
        menu.customBackgroundColor = [UIColor clearColor];
        menu.collectionViewColor = [UIColor whiteColor];
    }
    menu.delegate = self;
    menu.dataSource = self;
    
    [self.menuView addSubview:menu];
}

-(void)prepareShareView {
    self.shareCircleView = [[CFShareCircleView alloc] initWithSharers:@[[CFSharer twitter], [CFSharer facebook], [CFSharer vk]]];
    self.shareCircleView.delegate = self;
}

-(void)updateWeatherData {
    [self updateWeatherWithCallback:^(NSError *error) {
    }];
}
-(void)updateWeatherWithCallback:(UpdateDataCallback)callback {
    [[DataManager sharedInstance]updateWeatherForecastWithCallback:^(CityObject *cityObject, NSError *error) {
        if (!error) {
            if (callback) {
                callback(nil);
            }
        }
    }];
}

@end
