//
//  BDL_JsonSeriler.m
//  Bendilianxi
//
//  Created by Arsenal on 15/3/21.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "BDL_JsonSeriler.h"

@implementation BDL_JsonSeriler

+ (NSDictionary *)dictFromJsonString:(NSString *)jsonString{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return  [self dictFromJsonData:data];
}

+ (NSDictionary *)dictFromJsonData:(NSData *)jsonData{
    
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:kNilOptions
                                                         error:&error];
    if (error) {
        NSLog(@"%s -- error = %@",__func__,error);
        return nil;
    }
    
    if (dict == nil) {
        NSLog(@"%s -- json dict nil",__func__);
        return nil;
    }

    return dict;
}

+ (NSData *)jsonDataFromDict:(NSDictionary *)dict{
    BOOL isValid = [NSJSONSerialization isValidJSONObject:dict];
    if (isValid) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"%s -- error = %@",__func__,error);
            return nil;
        }
        
        if (data == nil) {
             NSLog(@"%s -- json data nil",__func__);
            return nil;
        }
        
        return data;
    }
    return nil;
}
@end
