//
//  WebLinkViewController.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 3/23/17.
//  Copyright © 2017 Yauheni Drobau. All rights reserved.
//

#import "WebLinkViewController.h"

#import "UIColor+BelarusNews.h"
#import "SettingsManager.h"
#import "Macros.h"

#define NOT_TO_ASK_KEY @"dontAsk"

@interface WebLinkViewController ()

@property (weak, nonatomic) IBOutlet UILabel *articleLinkLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonNO;
@property (weak, nonatomic) IBOutlet UIButton *ButtonYES;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic) BOOL isNotAskEnable;
@property (nonatomic) BOOL openLink;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *mainBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation WebLinkViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkButton.imageView.image = [self getCheckedImage];
    self.articleLinkLabel.text = self.link;
    [self setupDismissing];
    [self prepareMainView];
    [self setupAppearance];
}


#pragma mark - IBActions
- (IBAction)notAskButtonTouched:(id)sender {
    self.isNotAskEnable = !self.isNotAskEnable;
    [[NSUserDefaults standardUserDefaults]setBool:self.isNotAskEnable forKey:@"isNotAskEnable"];
    [self.checkButton setImage:[self getCheckedImage] forState:UIControlStateNormal];
}

- (IBAction)buttonNOTouched:(id)sender {
    self.openLink = NO;
    [[NSUserDefaults standardUserDefaults]setBool:self.openLink forKey:@"openLink"];
    [self closeTapped];
}

- (IBAction)buttonYESTouched:(id)sender {
    self.openLink = YES;
    [[NSUserDefaults standardUserDefaults]setBool:self.openLink forKey:@"openLink"];
    [self closeTapped];
}

#pragma mark - Private
-(UIImage*)getCheckedImage {
    if (self.isNotAskEnable) {
        return [UIImage imageNamed:@"check"];
    } else
        return [UIImage imageNamed:@"uncheck"];
}

- (void)setupDismissing {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapped)];
    [self.backgroundView addGestureRecognizer:gesture];
}

-(void)prepareMainView {
    self.mainView.layer.cornerRadius = 15;
    self.mainView.layer.borderWidth = 1;
    self.mainView.layer.borderColor = [UIColor bn_mainColor].CGColor;
}

-(void)setupAppearance {
    if ([SettingsManager sharedInstance].isNightModeEnabled) {
        self.mainView.layer.borderColor = [UIColor bn_mainNightColor].CGColor;
        self.articleLinkLabel.textColor = [UIColor bn_mainNightColor];
        self.mainBackgroundView.backgroundColor = [UIColor blackColor];
        [self.ButtonYES setBackgroundColor:[UIColor bn_mainNightColor]];
        [self.buttonNO setBackgroundColor:[UIColor bn_mainNightColor]];
    } else {
        self.mainView.layer.borderColor = [UIColor bn_mainColor].CGColor;
        self.articleLinkLabel.textColor = [UIColor bn_mainColor];
        self.mainBackgroundView.backgroundColor = [UIColor bn_newsCellColor];
        [self.ButtonYES setBackgroundColor:[UIColor bn_mainColor]];
        [self.buttonNO setBackgroundColor:[UIColor bn_mainColor]];
    }
}
- (void)closeTapped {
    if (self.closeButtonTappedBlock) {
        self.closeButtonTappedBlock ();
    }
    
    if (self.closed) {
        self.closed (self.isNotAskEnable,self.openLink);
    }
}
@end
