//
//  AppDelegate.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 01.09.16.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#warning зачем это здесь? Сделай FileHelper или что-то в этом роде, где ты будешь работать с файловой системой
- (NSURL *)applicationDocumentsDirectory;


@end

