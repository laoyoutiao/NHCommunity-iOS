//
//  ActiveBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/30.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "ActiveBiz.h"

@implementation ActiveBiz


- (void)requestActive:(NSDictionary *)param
            success:(void(^)(NSDictionary *responseObj))success
                 fail:(void(^)(NSString *errorMsg))fail{
    
    if (_curParamDict.count == 0) {
        [_curParamDict addEntriesFromDictionary:param];
    }

    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_ACTIVE_LIST]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self requestActive:_curParamDict
                                                                       success:success
                                                                          fail:fail];
                                                       }else{
                                                           fail(responObject[DATA_KEY_MSG]);
                                                       }
                                                   }else{
                                                       NSLog(@"final respoint = %@",responObject);
                                                       success(responObject);
                                                   }
                                                   
                                               } fail:^(NSError *error) {
                                                   fail(@"请求失败，请稍后再试!");
                                               }];
}

@end
