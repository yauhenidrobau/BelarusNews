//
//  CoreDataManager.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
#import "UIKit/UIKit.h"

@interface CoreDataManager : NSObject

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(CoreDataManager *)sharedInstance;
- (void)saveContext;
#warning applicationDocumentsDirectory - этот метод должен быть публичным? Где он еще используется?
- (NSURL *)applicationDocumentsDirectory;
-(void) saveFilms:(NSDictionary<NSString *,NSString *>*)films;
-(NSFetchedResultsController *) fetchedResultsController:(NSString *)entityName key:(NSString *)keyForSort;


- (void)saveContext;

@end
