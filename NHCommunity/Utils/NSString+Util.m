//
//  NSString+Util.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/8.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (BOOL)stringIsNull{
    if (self == nil) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self isKindOfClass:[NSString class]]) {
        NSString *validateStr = self;
        if (validateStr.length == 0 || [validateStr isEqualToString:@"<null>"] || [validateStr isEqualToString:@""] || [validateStr isEqualToString:@"(null)"]) {
            return YES;
        }else
            return NO;
    }else{
        return NO;
    }
}

- (BOOL)stringStartwithHttp{
    if ([self rangeOfString:@"http://"].location != NSNotFound) {
        return YES;
    }
    return NO;
}
@end
