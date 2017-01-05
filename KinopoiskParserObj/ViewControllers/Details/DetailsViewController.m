//
//  DetailsViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DetailsViewController.h"

#import "FXBlurView.h"
#import "UIColor+flat.h"
#import "FeSpinnerTenDot.h"

@interface DetailsViewController () <FeSpinnerTenDotDelegate>
{
    NSInteger index;
}
@property (strong, nonatomic) FeSpinnerTenDot *spinner;
@property (strong, nonatomic) NSArray *arrTitile;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;

@end

@implementation DetailsViewController

#pragma mark - Lifecycle

 -(void) viewDidLoad{
     [super  viewDidLoad];
     
     self.webView.hidden = YES;
     [self.navigationController setHidesBarsOnSwipe:YES];

     self.view.backgroundColor = [UIColor colorWithHexCode:@"#019875"];
     
     //*********
     index = 0;
     _arrTitile = @[@"LOADING",@"PLZ WAITING",@"CALM DOWN",@"SUCCESSFUL"];
     
     // init Loader
     _spinner = [[FeSpinnerTenDot alloc] initWithView:self.view withBlur:NO];
     _spinner.titleLabelText = _arrTitile[index];
     _spinner.fontTitleLabel = [UIFont fontWithName:@"Neou-Thin" size:36];
     _spinner.delegate = self;
     
     [self.view addSubview:_spinner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:7.0f];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    [self start:self];

    [self.webView layoutIfNeeded];
    if (_newsUrl) {
        NSLog(@"%@",_newsUrl);
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

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

-(void) webViewDidStartLoad:(UIWebView*)webView {
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [self dismiss:self];
}

- (IBAction)start:(id)sender
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
    }
    
    [_spinner showWhileExecutingSelector:@selector(longTask) onTarget:self withObject:nil completion:^{
        [_timer invalidate];
        _timer = nil;
        
        index = 0;
        _containerView.hidden = YES;
    }];
}

-(void) longTask
{
    // Do a long take
    sleep(5);
}
- (IBAction)dismiss:(id)sender
{
    [_timer invalidate];
    [_spinner dismiss];
    
    // pop
    _containerView.hidden = YES;
}
-(void) changeTitle
{
    NSLog(@"index = %ld",index);
    
    if (index >= _arrTitile.count)
        return;
    
    _spinner.titleLabelText = _arrTitile[index];
    index++;
}
-(void) FeSpinnerTenDotDidDismiss:(FeSpinnerTenDot *)sender
{
    NSLog(@"did dismiss");
}
//- (void)clearCookies
//{
//    NSHTTPCookieStorage *storage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
//    
//    for (NSHTTPCookie *cookie in storage.cookies)
//        [storage deleteCookie:cookie];
//    
//    [NSUserDefaults.standardUserDefaults synchronize];
//}
@end
