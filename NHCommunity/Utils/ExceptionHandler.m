//
//  ExceptionHandler.m
//  TestLogComponet
//
//  Created by gao on 13-6-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ExceptionHandler.h"


NSString *applicationDocumentPath(){
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void GwExceptionHandler(NSException *exception){
    
    if ([[[UIDevice currentDevice] model] hasSuffix:@"similator"]) {
        return;
    }
    
    NSArray *array = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *url = [NSString stringWithFormat:@"=============error report =============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[array componentsJoinedByString:@"\n"]];
    NSString *path = [applicationDocumentPath() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@implementation ExceptionHandler



+(void)setDefualtExceptionHandler{
    NSSetUncaughtExceptionHandler(&GwExceptionHandler);
}

+(NSUncaughtExceptionHandler *)getExceptionHandler{
    return NSGetUncaughtExceptionHandler();
}




@end
