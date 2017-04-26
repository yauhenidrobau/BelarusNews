//
//  FilterNewsViewController.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 4/26/17.
//  Copyright © 2017 Yauheni Drobau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewController.h"

@interface FilterNewsViewController : ModalViewController

@property (nonatomic, strong) void (^closed)();

@end
