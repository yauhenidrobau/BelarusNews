//
//  MenuViewController.h
//  BelarusNews
//
//  Created by Admin on 02/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    DevByCategory = 0,
    TutBYCategory = 1,
    YandexCategory = 2,
    MtsByCategory = 3
}CategoryTypes;

@interface MenuViewController :UIViewController

@property (strong, nonatomic) NSString *titleString;

@end
