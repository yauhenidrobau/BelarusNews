//
//  Macros.h
//  KinopoiskParserObj
//
//  Created by YAUHENI DROBAU on 22/11/2016.
//  Copyright © 2016 YAUHENI DROBAU. All rights reserved.
//
#define SINGLETON(classname) \
+ (classname *)sharedInstance { \
static dispatch_once_t pred; \
__strong static classname * shared##classname = nil; \
dispatch_once( &pred, ^{ \
shared##classname = [[self alloc] init]; }); \
return shared##classname; \
}

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

