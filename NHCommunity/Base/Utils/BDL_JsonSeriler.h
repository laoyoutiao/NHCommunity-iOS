//
//  BDL_JsonSeriler.h
//  Bendilianxi
//
//  Created by Arsenal on 15/3/21.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDL_JsonSeriler : NSObject

+ (NSDictionary *)dictFromJsonString:(NSString *)jsonString;

+ (NSDictionary *)dictFromJsonData:(NSData *)jsonData;

+ (NSData *)jsonDataFromDict:(NSDictionary *)dict;
@end
