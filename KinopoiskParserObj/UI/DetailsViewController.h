//
//  DetailsViewController.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIWebViewDelegate>
#warning зачем делать метод newInstance для контроллера? 
+(id)newInstance;
@property(nonatomic, strong) NSURL *newsUrl;

@end
