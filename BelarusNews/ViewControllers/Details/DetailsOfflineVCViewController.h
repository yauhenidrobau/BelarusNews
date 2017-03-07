//
//  DetailsOfflineVCViewController.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEntity.h"
#import "NewsTableViewCell.h"

@interface DetailsOfflineVCViewController : UIViewController

@property (nonatomic, strong) NewsEntity *entity;
@property (nonatomic, strong) NSString *sourceLink;

@end
