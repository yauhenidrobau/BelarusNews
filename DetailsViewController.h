//
//  DetailsViewController.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property(nonatomic, weak) NSURL *newsUrl;
@end
