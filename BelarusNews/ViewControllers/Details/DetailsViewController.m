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

@end

@implementation DetailsViewController

#pragma mark - Lifecycle

-(void)viewDidLoad{
     [super  viewDidLoad];
     
     self.webView.hidden = YES;
     index = 0;
     _arrTitile = @[NSLocalizedString(@"LOADING",nil),NSLocalizedString(@"PLEASE WAITING",nil),NSLocalizedString(@"CALM DOWN",nil),NSLocalizedString(@"WAITING",nil)];
     [self.containerView layoutIfNeeded];
     // init Loader
     _spinner = [[FeSpinnerTenDot alloc] initWithView:self.containerView withBlur:NO];
     _spinner.titleLabelText = _arrTitile[index];
     _spinner.fontTitleLabel = [UIFont fontWithName:@"Neou-Thin" size:36];
     _spinner.delegate = self;
    
     [self.view addSubview:_spinner];
     [self.webView layoutIfNeeded];
     if (_sourceLink.length) {
         NSLog(@"%@",_sourceLink);
         NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:_sourceLink]];
         [self.webView loadRequest:request];
         [self start:self];
     }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(animated)];
    
    if (self.webView.hidden) {
        self.webView.hidden = NO;
    }
    
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        [self updateForNightMode:YES];
    } else {
        [self updateForNightMode:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dismiss:self];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView*)webView {
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;

    [self dismiss:self];
    if (![SettingsManager sharedInstance].isNightModeEnabled) {
        [self.navigationController.navigationBar setTintColor:[UIColor bn_navBarTitleColor]];
    }
}

#pragma mark - IBActions

- (IBAction)start:(id)sender
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
    }
    [_spinner show];
}

- (IBAction)dismiss:(id)sender
{
    [_timer invalidate];
    [_spinner dismiss];
    _timer = nil;
    index = 0;
    _containerView.hidden = YES;

}

#pragma mark Private

-(void)changeTitle
{
    NSLog(@"index = %ld",(long)index);
    if (index >= _arrTitile.count) {
        _spinner.titleLabelText = _arrTitile[3];
    }else {
    _spinner.titleLabelText = _arrTitile[index];
    }
    index++;
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
