//
//  DetailsOfflineVCViewController.m
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 28/12/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import "DetailsOfflineVCViewController.h"

@interface DetailsOfflineVCViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailsDescriptionTV;

@end

@implementation DetailsOfflineVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailsTitleLabel.text = [self stringByStrippingHTML:self.detailsTitle];
//    NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                            initWithData: [self.detailsDescription dataUsingEncoding:NSUnicodeStringEncoding]
//                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                        NSFontAttributeName: [UIFont systemFontOfSize:17]}
//                                            documentAttributes: nil
//                                            error: nil
//                                            ];
    self.detailsDescriptionTV.font = [UIFont systemFontOfSize:17.0];
    self.detailsDescriptionTV.text = [self stringByStrippingHTML:self.detailsDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
