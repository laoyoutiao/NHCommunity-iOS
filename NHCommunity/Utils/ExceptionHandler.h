//
//  ExceptionHandler.h
//  TestLogComponet
//
//  Created by gao on 13-6-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionHandler : NSObject

+(void)setDefualtExceptionHandler;

+(NSUncaughtExceptionHandler *)getExceptionHandler;

@end
