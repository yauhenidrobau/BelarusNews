//
//  DetailsViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DetailsViewController.h"

@implementation DetailsViewController
@synthesize webView;
@synthesize navigationBarHidden;

NSURL *newsUrl;

//MARK: Lifecycle
 -(void) viewDidLoad{
     [super  viewDidLoad];
    
     webView.hidden = true;
    
}

- (void)viewDidAppear:(BOOL)animated {
    //activityInd.hidden = true;
    if (newsUrl != nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL: newsUrl];
        [webView loadRequest:request];
    }
    if (webView.hidden) {
        webView.hidden = false;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    
    navigationBarHidden = false;
    
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) webViewDidStartLoad:(UIWebView*)webView {
   // activityInd.hidden = false
   // activityInd.startAnimating()
}
/*
func webViewDidFinishLoad(webView: UIWebView) {
    activityInd.hidden = true
    activityInd.stopAnimating()
}
*/
@end
