//
//  CheckBoxView.m
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 4/17/17.
//  Copyright © 2017 Yauheni Drobau. All rights reserved.
//

#import "CheckBoxView.h"

#import "Constants.h"
#import "Utils.h"

@interface CheckBoxView ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (strong, nonatomic) NSArray *categoriesMenu;
@end

@implementation CheckBoxView

#pragma mark - LifeCycle

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.mainView];
        
        [self.mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":self.mainView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":self.mainView}]];
        
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self addTapHandler];
    self.categoriesMenu = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:CATEGORIES_KEY]]];
    self.checked = [self.categoriesMenu[0][@"Checked"] boolValue];
    [self updateImageAnimated:NO];
}

- (void)updateImageAnimated:(BOOL)animated
{
    NSString *imageName = self.checked ? @"checkmark" : @"unCheck";
    
    if (animated) {
        [UIView transitionWithView:self.iconView duration:0.15f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.iconView.image = [UIImage imageNamed:imageName];
        } completion:nil];
    }
    else {
        self.iconView.image = [UIImage imageNamed:imageName];
    }
}

-(void)checkboxTapped {
    self.checked = !self.checked;
}

-(void)addTapHandler {
    UITapGestureRecognizer *tapRecongnizer = [[UITapGestureRecognizer alloc] init];
    [tapRecongnizer addTarget:self action:@selector(checkboxTapped)];
    
    [self addGestureRecognizer:tapRecongnizer];
}

#pragma mark - Properties

-(void)setTitleString:(NSString *)titleString {
    self.titleLabel.text = titleString;
    _titleString = titleString;
}

-(void)setChecked:(BOOL)checked
{
    _checked = checked;
    self.categoriesMenu = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:CATEGORIES_KEY]]];

    if (self.titleString) {
        for (NSMutableDictionary *dict in self.categoriesMenu) {
            if ([dict[@"SourceName"] isEqualToString:self.titleString]) {
                [dict setObject:@(checked) forKey:@"Checked"];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:self.categoriesMenu] forKey:CATEGORIES_KEY];
        [self updateImageAnimated:YES];
    }
}

@end
