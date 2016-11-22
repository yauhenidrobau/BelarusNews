//
//  DetailsViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DetailsViewController.h"

@implementation DetailsViewController

#warning зачем тут @synthesize ???
@synthesize webView;
@synthesize navigationBarHidden;
@synthesize url;
@synthesize activityInd;

//NSURL *url;

#pragma mark - Lifecycle

+ (id)newInstance {
#warning если у тебя один сториборд, то можно просто писать self.storyboard
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    id vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    return vc;
}
 -(void) viewDidLoad{
     [super  viewDidLoad];
     webView.hidden = true;
}

- (void)viewDidAppear:(BOOL)animated {
#warning почему нет super viewDidAppear:animated ???
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    //activityInd.hidden = true;
#warning дублирование кода 1
    activityInd.hidden = false;
    [activityInd startAnimating];
    _newsUrl = [NSURL URLWithString:url];
    [webView layoutIfNeeded];
    //    _newsUrl = url;
#warning можео делать проверку if (_newsUrl) { ... }
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
#warning почему не сделать метод showLoadingIndicator:(BOOL)show и в нем либо показывать, либо прятать? А если тебе потом нужно будет показывать какой-то другой индикатор? В скольких местах тебе нужно будет поменять код?
#warning дублирование кода 2    
    activityInd.hidden = true;
    [activityInd stopAnimating];
}

@end
