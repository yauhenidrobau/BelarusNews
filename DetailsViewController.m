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
@synthesize url;
@synthesize activityInd;

NSURL *url;

#pragma mark - Lifecycle
 -(void) viewDidLoad{
     [super  viewDidLoad];
    
     webView.hidden = true;
    
}

- (void)viewDidAppear:(BOOL)animated {
    //activityInd.hidden = true;
    _newsUrl = [NSURL URLWithString:url];
    //_newsUrl = url;
    if (_newsUrl != nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL: _newsUrl];
        [webView loadRequest:request];
    }
    if (webView.hidden) {
        webView.hidden = false;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIWebViewDelegate

-(void) webViewDidStartLoad:(UIWebView*)webView {
    activityInd.hidden = false;
    [activityInd startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    activityInd.hidden = true;
    [activityInd stopAnimating];
}

@end
