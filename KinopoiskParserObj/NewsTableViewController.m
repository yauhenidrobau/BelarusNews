//
//  NewsTableViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "NewsTableViewController.h"
#import "CoreDataManager.h"
#import "DataManager.h"
#import "Film.h"
#import "NewsTableViewCell.h"
#import "DetailsViewController.h"

@interface NewsTableViewController () 

@property(nonatomic,weak) UILabel *titleLabel;

@end

@implementation NewsTableViewController


@synthesize navigationBarHidden;


#pragma mark - Properties

NSFetchedResultsController *fetchedResultsController = nil;


#pragma mark - Lifecycle
-(void) initFetchResultController{
    fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsController:@"Film" key:@"titleFeed"];
    fetchedResultsController.delegate = self;
}
-(void) viewDidLoad {

    [super viewDidLoad];
    [self setAppierance];
    [self initFetchResultController];
    [self updateData];
    [self loadData];
   // [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated {
    navigationBarHidden = true;
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray  *sections = fetchedResultsController.sections;
    
    return sections.count > section ? [sections[section] numberOfObjects] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
   NSArray *sections = fetchedResultsController.sections;
    return sections.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    Film *filmItem = [fetchedResultsController objectAtIndexPath:(indexPath)];
    cell.titleLabel.text = filmItem.titleFeed;
    cell.descriptionLabel.text = filmItem.descriptionFeed;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Film *filmItem =  [fetchedResultsController objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"details" sender:filmItem.linkFeed];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
        DetailsViewController *destinationController = (DetailsViewController *)segue.destinationViewController;
    NSString *url = sender;
    destinationController.url = [[NSString alloc] initWithString:url];
  
}


#pragma mark - NSFetchedResultsControllerDelegate


//check if there is some changes in Data Base
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    switch (type) {
    case  NSFetchedResultsChangeInsert:
            
            if (newIndexPath != indexPath) {
                NSArray <NSIndexPath *> * _newIndexPath =[[NSArray<NSIndexPath *> alloc] initWithObjects:newIndexPath,nil];
                
                [self.tableView insertRowsAtIndexPaths:_newIndexPath withRowAnimation: UITableViewRowAnimationFade];
                
              
            }
            break;
    case NSFetchedResultsChangeDelete:
            if (newIndexPath != nil) {
                NSArray <NSIndexPath *> * _newIndexPath =[[NSArray<NSIndexPath *> alloc] initWithObjects:newIndexPath,nil];

            [self.tableView deleteRowsAtIndexPaths:_newIndexPath withRowAnimation: UITableViewRowAnimationFade];
            }
            break;
    case NSFetchedResultsChangeUpdate:
            
            if (newIndexPath != nil) {
               NSArray <NSIndexPath *> * _newIndexPath =[[NSArray<NSIndexPath *> alloc] initWithObjects:newIndexPath,nil];
                            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
           
    default:
            [self.tableView reloadData];
            break;
            
    }
}

- (nullable NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName{
    return sectionName;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
    case NSFetchedResultsChangeInsert:
        
            
            if(sectionIndex != 0){
                
                NSIndexSet *sectionIndexSet = [[NSIndexSet alloc]initWithIndex:sectionIndex];
            [self.tableView insertSections:sectionIndexSet withRowAnimation:UITableViewRowAnimationFade];
            }
    case NSFetchedResultsChangeDelete:
            
            if(sectionIndex != 0){
                NSIndexSet *sectionIndexSet = [[NSIndexSet alloc]initWithIndex:sectionIndex];
                [self.tableView deleteSections:sectionIndexSet withRowAnimation: UITableViewRowAnimationFade];
            }
    default:
        @"";
    }
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}
/*
- (UIStatusBarStyle)preferredStatusBarStyle NS_AVAILABLE_IOS(7_0) {
    return UIStatusBarStyle  .Default
}
*/
 
-(void) setAppierance {
    // auto re-sizing cell
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
}

-(void) loadData {
    
    NSError *error;
     [fetchedResultsController performFetch:&error];
    
}

-(void)updateData {
    
    [[DataManager sharedInstance ] updateData];
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
  
    // Configure the cell...
  
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
