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

//NSFetchedResultsController *fetchedResultsController = nil;
RLMResults<NewsEntity*> *newsArray = nil;

-(NSArray *)array {
    if (!_array) {
        _array = @[@"dev.by",@"tut.by",@"yandex"];
    }
    return _array;
}
#pragma mark - Lifecycle

-(void)initRealmArray{
//    fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController:@"Film" key:@"titleFeed"];
//    fetchedResultsController.delegate = self;
    newsArray = [NewsEntity objectsWhere:@"feedIdString == %@",self.array[self.NewsSegmentedControl.selectedSegmentIndex]];
}
-(void)viewDidLoad {

    [super viewDidLoad];
    [self setAppierance];
    [self updateData];
    [self initRealmArray];
//    [self loadData];
    self.scrollButton.hidden = YES;
    
   // self.scrollButton.layer.cornerRadius = [self.scrollButton frame].size.height / 2;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"Back"];
    [self.navigationController setHidesBarsOnSwipe:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

#pragma mark - NSFetchedResultsControllerDelegate

//check if there is some changes in Data Base
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
//    switch (type) {
//    case  NSFetchedResultsChangeInsert:
//            
//            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationFade];
//            break;
//            
//    case NSFetchedResultsChangeDelete:
//            
//            [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationFade];
//            break;
//    case NSFetchedResultsChangeUpdate:
//            
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//           
//    default:
//            [self.tableView reloadData];
//            break;
//            
//    }
//}


//- (nullable NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName{
//    return sectionName;
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
//    [self.tableView endUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    
//    switch (type) {
//    case NSFetchedResultsChangeInsert:
//        
//            
//            if(sectionIndex != 0){
//                
//                NSIndexSet *sectionIndexSet = [[NSIndexSet alloc]initWithIndex:sectionIndex];
//            [self.tableView insertSections:sectionIndexSet withRowAnimation:UITableViewRowAnimationFade];
//            }
//    case NSFetchedResultsChangeDelete:
//            
//            if(sectionIndex != 0){
//                NSIndexSet *sectionIndexSet = [[NSIndexSet alloc]initWithIndex:sectionIndex];
//                [self.tableView deleteSections:sectionIndexSet withRowAnimation: UITableViewRowAnimationFade];
//            }
//    default:
//        @"";
//    }
//}

//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
//    [self.tableView beginUpdates];
//}

#pragma mark UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;
    CGFloat height = scrollView.frame.size.height;
    if (currentOffset.y > self.lastContentOffset.y && currentOffset.y > 0 )
    {
        self.scrollButton.hidden = NO;
    }
    else
    {
        self.scrollButton.hidden = YES;
        // Upward
    }
    self.lastContentOffset = currentOffset;
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - currentOffset.y;
    
    if(distanceFromBottom <= height)
    {
        self.scrollButton.hidden = NO;
    }
}

- (IBAction)scrollButtonTouchUpInside:(id)sender {
    [UIView animateWithDuration:0.9 animations:^{
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }];
//    [self.tableView setContentOffset:CGPointZero animated:YES];
    self.scrollButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)changeValueSC:(id)sender {
    [self.activityInd setHidden:NO];
    [self.activityInd startAnimating];
    [[DataManager sharedInstance ] updateDataWithURLString:self.array[self.NewsSegmentedControl.selectedSegmentIndex] AndCallBack:^(NSError *error) {
        if (error == nil) {
            [self initRealmArray];
            [self.tableView reloadData];
            [self.activityInd stopAnimating];
            [self.activityInd setHidden:YES];
        }
    }];
}

#pragma mark - Private methods

-(void) setAppierance {
    // auto re-sizing cell
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
    [self.activityInd setHidden:YES];
}

-(void)updateData {
    [[DataManager sharedInstance ] updateDataWithURLString:self.array[self.NewsSegmentedControl.selectedSegmentIndex] AndCallBack:^(NSError *error) {
        if (error == nil) {
            [self.tableView reloadData];
        }
    }];
}
@end
