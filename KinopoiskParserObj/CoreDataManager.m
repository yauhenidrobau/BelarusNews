//
//  CoreDataManager.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "CoreDataManager.h"
#import <Coredata/CoreData.h>
#import "Film.h"

@implementation CoreDataManager

//Singleton
+(CoreDataManager *)sharedInstance {
    static dispatch_once_t pred;
    static CoreDataManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[CoreDataManager alloc]init];
    });
    return shared;
}


//Entity for Name
-(NSEntityDescription *)entityForName:(NSString *)entityName{
  //  CoreDataManager * shared = [CoreDataManager shared];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext: [CoreDataManager sharedInstance].managedObjectContext];
            
}


-(NSFetchedResultsController *) fetchedResultsController:(NSString *)entityName key:(NSString *)keyForSort  {
  
    NSFetchRequest *fetchRequest = [NSFetchRequest  fetchRequestWithEntityName:@"Film"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titleFeed" ascending:YES ];

    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
   
    NSFetchedResultsController *fetchedResultsController =[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                              managedObjectContext:self.managedObjectContext
                                                                                                sectionNameKeyPath:nil
                                                                                                         cacheName:nil];
   // NSFetchedResultsController * fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil);
    return fetchedResultsController;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Cogniteq.KinopoiskParserObj" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KinopoiskParserObj" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KinopoiskParserObj.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



-(void) saveFilms:(NSDictionary<NSString *,NSString *>*)films {
        // Set value to Context
    for (NSMutableDictionary<NSString *,NSString *>*filmInfo in films.allValues) {
        //NSString *filmTitle = filmInfo[@"title"];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Film"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"titleFeed == %@"]];
        
            Film *filmToBeSaved;
          //NSMutableArray  *Film = [[NSMutableArray alloc]init];
          NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:(NSFetchRequest *)fetchRequest error:nil ];
            
                if (fetchResults.count > 0) {
                    Film *film_ = fetchResults.firstObject;
                    filmToBeSaved = film_;
                    
                }
                else {
                    //begin create film
                   NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:self.managedObjectContext];
                    Film  *filmEntity = [[Film alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
                    filmToBeSaved = filmEntity;
                    
                    Film  *filmToBeSaved_ = filmToBeSaved;
                    //refresh data
                    
                    filmToBeSaved_.titleFeed = filmInfo[@"title"];
                    filmToBeSaved_.descriptionFeed = filmInfo[@"description"];
                    filmToBeSaved_.pubDateFeed = filmInfo[@"pubDate"];
                    filmToBeSaved_.linkFeed = filmInfo[@"link"];
                    filmToBeSaved_.urlImage = filmInfo[@"urlImage"];
                    // SaveData
                    [ self saveContext];
                }
    }
    
}


@end
