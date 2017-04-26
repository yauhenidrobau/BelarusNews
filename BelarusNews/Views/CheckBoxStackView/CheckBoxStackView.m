//
//  CheckBoxStackView.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 4/26/17.
//  Copyright © 2017 Yauheni Drobau. All rights reserved.
//

#import "CheckBoxStackView.h"

#import "CheckBoxView.h"
#import "Utils.h"
#import "Constants.h"

@interface CheckBoxStackView ()

@property (weak, nonatomic) IBOutlet CheckBoxView *CBView1;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView2;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView3;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView4;
@property (weak, nonatomic) IBOutlet CheckBoxView *CBView5;
@property (weak, nonatomic) IBOutlet UIView *checkBoxView;

@property (strong, nonatomic) NSArray *CBArray;

@end

@implementation CheckBoxStackView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.checkBoxView];
        
        [self.checkBoxView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":self.checkBoxView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":self.checkBoxView}]];
        
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.CBArray = @[_CBView1,_CBView2,_CBView3,_CBView4,_CBView5];
    [Utils addShadowToView:self.checkBoxView];
    [self prepareCategories];
    
}

#pragma mark - Private

-(void)prepareCategories {
    NSArray *categories = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:CATEGORIES_KEY]]];
    for (NSInteger i = 0; i < self.CBArray.count; i++) {
        CheckBoxView *cbView = self.CBArray[i];
        cbView.titleString = categories[i][@"SourceName"];
        NSNumber *checked = categories[i][@"Checked"];
        
        cbView.checked = checked.integerValue;
    }
}

@end
