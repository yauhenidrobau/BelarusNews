//
//  FilterNewsViewController.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 4/26/17.
//  Copyright © 2017 Yauheni Drobau. All rights reserved.
//

#import "FilterNewsViewController.h"

#import "CheckBoxView.h"
#import "CheckBoxStackView.h"
#import "Constants.h"
#import "Utils.h"

@interface FilterNewsViewController ()

@property (weak, nonatomic) IBOutlet CheckBoxStackView *checkBoxStackView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation FilterNewsViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [Utils addShadowToView:self.closeButton];
    self.closeButton.layer.cornerRadius = self.closeButton.frame.size.height / 2;
}

#pragma mark IBAction
- (IBAction)closeButtonTouched:(id)sender {
    [self closeTapped];
}

#pragma mark - Public

- (void)closeTapped {
    if (self.closeButtonTappedBlock) {
        self.closeButtonTappedBlock ();
    }
    if (self.closed) {
        self.closed ();
    }
}


@end
