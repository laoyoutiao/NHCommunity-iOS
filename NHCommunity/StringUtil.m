//
//  StringUtil.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

//UUID
+(NSString *) generateUUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result lowercaseString];
}

@end
