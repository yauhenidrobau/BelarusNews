//
//  Film.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <Foundation/Foundation.h>
//@import CoreData;

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Film : NSManagedObject 

@property (nullable, nonatomic, retain) NSString *descriptionFeed;
@property (nullable, nonatomic, retain) NSString *linkFeed;
@property (nullable, nonatomic, retain) NSString *pubDateFeed;
@property (nullable, nonatomic, retain) NSString *titleFeed;
@property (nullable, nonatomic, retain) NSString *urlImage;// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Film+CoreDataProperties.h"
