//
//  QusetionBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/8.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "QusetionBiz.h"
#import "HttpManager.h"

@implementation QusetionBiz

- (void)requestQuestionList:(NSDictionary *)param
                    success:(void (^)(NSDictionary *))success
                       fail:(void (^)(NSString *))fail{
    
    if (_curParamDict.count == 0) {
        [_curParamDict addEntriesFromDictionary:param];
    }
//    [_curParamDict setObject:@"" forKey:@"token"];
//    
//    [[HttpManager shareInstant] httpPostWithNoAuthRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_GET_GUEST_BOOK] param:_curParamDict success:^(id responObject) {
//         NSLog(@"requestQuestionList success 不带验证 = %@",responObject);
//         success(responObject);
//    } fail:^(NSError *error) {
//         NSLog(@"requestQuestionList  error 不带验证 = %@",error);
//        fail(@"");
//    }];

    
    //!!!!! 下面为 带有session 和 token 逻辑 ！！！

    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_GET_GUEST_BOOK]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self requestQuestionList:_curParamDict
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
