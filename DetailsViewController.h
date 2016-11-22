//
//  DetailsViewController.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIWebViewDelegate>
+ (id)newInstance;
#warning почему паблик???
@property (weak, nonatomic) IBOutlet UIWebView *webView;
#warning зачем это тут?
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
#warning в чем отличие newsUrl и url? Оба используются?
@property(nonatomic, strong) NSURL *newsUrl;
@property(nonatomic, strong) NSString *url;
#warning почему паблик???
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@end
