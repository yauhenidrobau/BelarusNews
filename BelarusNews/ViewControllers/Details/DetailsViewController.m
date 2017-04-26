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

#import "Macros.h"
#import "Utils.h"
#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"

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
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@end

@implementation DetailsViewController

#pragma mark - Lifecycle

-(void)viewDidLoad{
     [super  viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
     self.webView.hidden = YES;
    self.webView.alpha = 0;
     index = 0;
    _urlTextField.text = _sourceLink;
     _arrTitile = @[NSLocalizedString(@"LOADING",nil),NSLocalizedString(@"PLEASE WAIT",nil),NSLocalizedString(@"CALM DOWN",nil),NSLocalizedString(@"WAIT",nil)];
    self.loadingLabel.text = _arrTitile[3];

     // init Loader
//     _spinner = [[FeSpinnerTenDot alloc] initWithView:self.containerView withBlur:NO];
//     _spinner.titleLabelText = _arrTitile[index];
//     _spinner.fontTitleLabel = [UIFont fontWithName:@"Neou-Thin" size:36];
//     _spinner.delegate = self;
//    
//     [self.view addSubview: _spinner];
//     [self.webView layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    
    if (_sourceLink.length) {
        NSLog(@"%@",_sourceLink);
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:_sourceLink]];
//        [self.webView loadRequest:request];
        [self start:self];
    }
    if (self.webView.hidden) {
        self.webView.hidden = NO;
    }
    
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        [self updateForNightMode:YES];
    } else {
        [self updateForNightMode:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dismiss:self];
}

#pragma mark IBActions
- (IBAction)pageGoBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)pageGoForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)goButtonTouched:(id)sender {
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:self.urlTextField.text]];
    [self.webView loadRequest:request];
    [self start:self];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView*)webView {
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.nextButton setEnabled:[self.webView canGoForward]];
    [self.previousButton setEnabled:[self.webView canGoBack]];
    if (![SettingsManager sharedInstance].isNightModeEnabled) {
        [self.navigationController.navigationBar setTintColor:[UIColor bn_navBarTitleColor]];
    }
}

#pragma mark - IBActions

- (IBAction)start:(id)sender
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
    }
//    [_spinner show];
}

- (IBAction)dismiss:(id)sender
{
    [_timer invalidate];
    [_spinner dismiss];
    _timer = nil;
    index = 0;
    [self showContainerView:NO];

}

#pragma mark Private

-(void)showContainerView:(BOOL)show {
    if (show) {
        _containerView.hidden = NO;
        self.webView.hidden = YES;
        self.webView.alpha = 0;

        [UIView animateWithDuration:1 animations:^{
            self.containerView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    } else {
        
        [UIView animateWithDuration:1.5 animations:^{
            self.containerView.alpha = 0;
            self.webView.hidden = NO;
            self.webView.alpha = 1;
        } completion:^(BOOL finished) {
            _containerView.hidden = YES;
        }];
    }
}

-(void)changeTitle {
    
    if ([[self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"loading"]) {
        NSLog(@"index = %ld",(long)index);
        CATransition *fade = [CATransition animation];
        fade.duration = 1;
        [self.loadingLabel.layer addAnimation:fade forKey:@"text"];
        if (index >= _arrTitile.count) {
            self.loadingLabel.text = _arrTitile[3];
            index = 0;
        }else {
            self.loadingLabel.text = _arrTitile[index];
        }
        index++;
    } else {
        [self dismiss:nil];
    }
}

-(void)FeSpinnerTenDotDidDismiss:(FeSpinnerTenDot *)sender
{
    NSLog(@"did dismiss");
}

-(void)updateForNightMode:(BOOL)update {
    if (update) {
        [Utils setNightNavigationBar:self.navigationController.navigationBar];
        [Utils setNavigationBar:self.navigationController.navigationBar light:YES];
    } else {
        [Utils setDefaultNavigationBar:self.navigationController.navigationBar];
        [Utils setNavigationBar:self.navigationController.navigationBar light:NO];
    }
}
@end
