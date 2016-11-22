//
//  DetailsViewController.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIWebViewDelegate>
+(id)newInstance;

#warning в чем отличие newsUrl и url? Оба используются?
@property(nonatomic, strong) NSURL *newsUrl;
#warning почему паблик???
@end
