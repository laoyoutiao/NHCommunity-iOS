//
//  MainPageBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/22.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "MainPageBiz.h"

@interface MainPageBiz(){
    
}

@end

@implementation MainPageBiz

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)requestNews:(NSDictionary *)param
            success:(void (^)(NSDictionary *))success
               fail:(void (^)(NSString *))fail{
    [self resetParamDictAndPageParam];
    [_curParamDict addEntriesFromDictionary:param];
    [_curParamDict addEntriesFromDictionary:_basePageParamDict];
    
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_NEW_BY_TIME]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self requestNews:_curParamDict
                                                                     success:success
                                                                        fail:fail];
                                                       }else{
                                                           fail(responObject[DATA_KEY_MSG]);
                                                       }
                                                   }else{
//                                                       NSLog(@"final respoint = %@",responObject);
                                                       success(responObject);
                                                   }

    } fail:^(NSError *error) {
        fail(@"请求失败，请稍后再试!");
    }];
}

- (void)refresh:(NSDictionary *)param
        success:(void (^)(NSDictionary *))success
           fail:(void (^)(NSString *))fail{
    [_curParamDict addEntriesFromDictionary:param];
//    [_curParamDict addEntriesFromDictionary:_basePageParamDict];
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_NEW_BY_TIME]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self refresh:_curParamDict
                                                                 success:success
                                                                    fail:fail];
                                                       }else{
                                                           fail(responObject[@"msg"]);
                                                       }
                                                   }else{
//                                                       NSLog(@"final respoint = %@",responObject);
                                                       success(responObject);
                                                   }
                                                   
                                               } fail:^(NSError *error) {
                                                   fail(@"请求失败，请稍后再试!");
                                               }];
}

@end
