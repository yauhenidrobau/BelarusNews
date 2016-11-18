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

//NSURL *url;

#pragma mark - Lifecycle

+ (id)newInstance {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    id vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    return vc;
}
 -(void) viewDidLoad{
     [super  viewDidLoad];
     webView.hidden = true;
}

- (void)viewDidAppear:(BOOL)animated {
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    //activityInd.hidden = true;
    activityInd.hidden = false;
    [activityInd startAnimating];
    _newsUrl = [NSURL URLWithString:url];
    [webView layoutIfNeeded];
    //    _newsUrl = url;
    if (_newsUrl != nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL: _newsUrl];
        [webView loadRequest:request];
    }
    if (webView.hidden) {
        webView.hidden = false;
    }
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIWebViewDelegate

-(void) webViewDidStartLoad:(UIWebView*)webView {
   
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    activityInd.hidden = true;
    [activityInd stopAnimating];
}

@end
