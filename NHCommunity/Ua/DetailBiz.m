//
//  detailBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/30.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "DetailBiz.h"

@implementation DetailBiz

- (void)requestDetail:(NSDictionary *)param
              success:(void(^)(NSDictionary *responseObj))success
                 fail:(void(^)(NSString *errorMsg))fail{
    
    if (_curParamDict.count == 0) {
        [_curParamDict addEntriesFromDictionary:param];
    }
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_CONTENT_DETAIL]);
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_CONTENT_DETAIL]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   NSLog(@"%@ ------ %@" ,reRequest,responObject);
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self requestDetail:_curParamDict
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

- (void)requestActiveDetail:(NSDictionary *)param success:(void (^)(NSDictionary *))success fail:(void (^)(NSString *))fail{
    if (_curParamDict.count == 0) {
        [_curParamDict addEntriesFromDictionary:param];
    }
    
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_ACTIVE_DETAIL]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self requestActiveDetail:_curParamDict
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
