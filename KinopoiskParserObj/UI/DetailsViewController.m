//
//  DetailsViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;

@end

@implementation DetailsViewController

#pragma mark - Lifecycle

 -(void) viewDidLoad{
     [super  viewDidLoad];
     self.webView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    [self showLoadingIndicator:NO];
    [self.webView layoutIfNeeded];
    if (_newsUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL: _newsUrl];
        [self.webView loadRequest:request];
    }
    if (self.webView.hidden) {
        self.webView.hidden = NO;
    }
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

-(void)dealloc {
    self.webView = nil;
}
-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

-(void) webViewDidStartLoad:(UIWebView*)webView {
   
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [self showLoadingIndicator:YES];
}

-(void)showLoadingIndicator:(BOOL)show {
    self.activityInd.hidden = show;
    if (!show) {
        [self.activityInd startAnimating];
    } else {
        [self.activityInd stopAnimating];
    }
}
@end
