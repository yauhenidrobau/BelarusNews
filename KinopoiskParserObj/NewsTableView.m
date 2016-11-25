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
#import "SearchResultsTableViewController.h"


#define YANDEX_NEWS @"https://st.kp.yandex.net/rss/news_premiers.rss"
#define TUT_BY_NEWS @"http://news.tut.by/rss/all.rss"
#define DEV_BY_NEWS @"https://dev.by/rss"

typedef void(^UpdateDataCallback)(NSError *error);

@interface NewsTableView () <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchResultsUpdating,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *NewsSegmentedControl;
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

@end

@implementation NewsTableView

#pragma mark - Lifecycle

-(void)viewDidLoad {

    [super viewDidLoad];
    [self setAppierance];
    [self updateDataWithIndicator:YES];
    [self setupData];
    [self addPullToRefresh];
    self.scrollButton.hidden = YES;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
#warning [self.navigationItem setTitle:@"Back"]; - что ты этим делаешь? Если заголовок кнопки back, то это не очень хороший вариант!
    [self.navigationItem setTitle:@"Back"];
    [self.navigationController setHidesBarsOnSwipe:YES];
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefreshBtnTouch)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    UINavigationController *searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsTableViewController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    [self.searchBar sizeToFit];
    self.searchController.searchBar.frame = self.searchBar.frame;
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
//    self.navigationItem.leftBarButtonItem = searchBarItem;

    
//    CGRectMake(self.searchController.searchBar.frame.origin.x,
//               self.searchController.searchBar.frame.origin.y,
//               self.searchController.searchBar.frame.size.width, 44.0);
    
//    self.searchController.searchBar.frame = self.searchBar.frame;
//    self.searchBar = self.searchController.searchBar;
   // self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.scrollButton.layer.cornerRadius = [self.scrollButton frame].size.height / 2;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(NSArray *)urlArray {
#warning На что здесь проверка идет? Если массив создан, но в нем нет элементов, то проверка if (_urlArray) вернут тру, но он будет пустой
    if (!_urlArray) {
        _urlArray = [NSArray arrayWithObjects:DEV_BY_NEWS,TUT_BY_NEWS,YANDEX_NEWS, nil];
    }
    return _urlArray;
}

-(NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"dev.by",@"tut.by",@"yandex"];
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
#warning плохо в плане работы с памятью. В блоке должна быть слабая ссылка, а не сильная self
    [UIView animateWithDuration:0.9 animations:^{
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }];
    self.scrollButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)changeValueSC:(id)sender {
    [self updateDataWithIndicator:YES];
}

#pragma mark - DZNEmptyDataSetSource

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No News Found";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Make sure that you turn on network.";
    
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

    cell.titleLabel.text = newsEntity.titleFeed;
    cell.descriptionLabel.text = newsEntity.descriptionFeed;
    if (newsEntity.urlImage) {
#warning если картинки большие и долго загружаются, то таблица будет дергаться, потому что ты грузишь картинки в главном потоке.
        cell.imageNewsView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newsEntity.urlImage]]];
    } else {
        cell.imageNewsView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]]];
    }
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsEntity *newsEntity = self.newsArray[indexPath.row];
    DetailsViewController *vc = [DetailsViewController newInstance];
    vc.newsUrl =[NSURL URLWithString:newsEntity.linkFeed];
    [vc.navigationItem setTitle:self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#warning сделай через Segue!!!
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
   
    NSString *searchString = self.searchController.searchBar.text;
    [self updateFilteredContentForNewsTitle:searchString];
    if (self.searchController.searchResultsController) {
        UINavigationController *navigationVC = (UINavigationController *)self.searchController.searchResultsController;
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navigationVC.topViewController;
        vc.searchResults = self.searchResults;
        vc.titlesArray = self.titlesArray;
        [vc.tableView reloadData];
        
    }
}

-(void)updateFilteredContentForNewsTitle:(NSString *)newsTitle {
    if (!newsTitle) {
        self.searchResults = [newsArray mutableCopy];
    } else {
        NSMutableArray *searchResults = [NSMutableArray new];
        for (NSInteger i = 0;i < newsArray.count;i++) {
            NewsEntity *entity = newsArray[i];
            if ([entity.titleFeed containsString:newsTitle]) {
                [searchResults addObject:entity];
            }
        }
        self.searchResults = searchResults;
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollButton.hidden = !(scrollView.contentOffset.y > 50);
}

#pragma mark - Private methods

-(void)addPullToRefresh {
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor colorWithRed:173/255.0 green:31/255.0 blue:45/255.0 alpha:1.0];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

-(void)setAppierance {
    // auto re-sizing cell
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
    [self.activityInd setHidden:YES];
}

-(void)setupData{
    newsArray = [NewsEntity objectsWhere:@"feedIdString == %@",self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex]];
//    if (!newsArray) {
//        [self.tableView setScrollEnabled:NO];
//        [self.activityInd stopAnimating];
//        [refreshControl endRefreshing];
//    }
}

-(void)showLoadingIndicator:(BOOL)show {
    self.activityInd.hidden = !show;
    if (show) {
        [self.activityInd startAnimating];
    }else {
        [self.activityInd stopAnimating];
    }
}

-(void)updateDataWithIndicator:(BOOL)showIndicator {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
#warning Почитай, как делается поддержка нескольких языков в приложении NSLocalizedString(key, comment). Все строки храни в Localized файлах.
        [UIAlertController  showAlertInViewController:self
                                           withTitle:@"We have problems"
                                             message:@"No Network :("
                                   cancelButtonTitle:@"OK"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil
                                            tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                [self showLoadingIndicator:NO];

                                            }];
    }else {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        if(status == NotReachable)
        {
            [UIAlertController  showAlertInViewController:self
                                                withTitle:@"We have problems"
                                                  message:@"No Network :("
                                        cancelButtonTitle:@"OK"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:nil
                                                 tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                     [self showLoadingIndicator:NO];

                                                 }];
        } else {
#warning неправильно. [[DataManager sharedInstance ] updateDataWithURLString - вот это ты должен вызывать в main потоке и возвращать даныне тоже в main. А внутри работать с фоновым потоком.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[DataManager sharedInstance ] updateDataWithURLString:self.urlArray[self.NewsSegmentedControl.selectedSegmentIndex] AndTitleString:self.titlesArray[self.NewsSegmentedControl.selectedSegmentIndex] WithCallBack:^(NSError *error) {
                if (error == nil) {
                    NSLog(@"GET ELEMENTS %ld",newsArray.count);
                    [self setupData];
                    [self.activityInd stopAnimating];
                    [self.activityInd setHidden:YES];
                    [refreshControl endRefreshing];
                    [self.tableView reloadData];
                    

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setupData];

#warning вот эти две строки должен вынести в отдельный метод и там либо показывать, либо скрывать индикатор
                            [self.activityInd stopAnimating];
                            [self.activityInd setHidden:YES];
#warning опять же сильная ссылка внутри блока
                            [refreshControl endRefreshing];
                            [self.tableView reloadData];
                        });
                }
            }];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLoadingIndicator:showIndicator];
            });
            
        }
    }
}
@end
