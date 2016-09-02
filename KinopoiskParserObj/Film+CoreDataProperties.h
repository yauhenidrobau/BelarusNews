//
//  Film+CoreDataProperties.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Film.h"

NS_ASSUME_NONNULL_BEGIN

@interface Film (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *descriptionFeed;
@property (nullable, nonatomic, retain) NSString *linkFeed;
@property (nullable, nonatomic, retain) NSString *pubDateFeed;
@property (nullable, nonatomic, retain) NSString *titleFeed;
@property (nullable, nonatomic, retain) NSString *urlImage;

@end

NS_ASSUME_NONNULL_END
