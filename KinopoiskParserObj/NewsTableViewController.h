//
//  NewsTableViewController.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NewsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> 

//@property(nonatomic, copy) NSFetchedResultsController * fetchedResultsController;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;

@end
