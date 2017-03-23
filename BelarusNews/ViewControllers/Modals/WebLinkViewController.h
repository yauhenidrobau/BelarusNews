//
//  WebLinkViewController.h
//  BelarusNews
//
//  Created by YAUHENI DROBAU on 3/23/17.
//  Copyright © 2017 Yauheni Drobau. All rights reserved.
//

#import "ModalViewController.h"


@interface WebLinkViewController : ModalViewController

@property (nonatomic, strong) void (^closed)(BOOL isNotAskEnable, BOOL openLink);
@property (nonatomic, strong) NSString *link;

@end
