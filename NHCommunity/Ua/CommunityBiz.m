//
//  CommunityBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/31.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "CommunityBiz.h"

@implementation CommunityBiz

- (void)requestCommunitMsg:(NSDictionary *)param
                   success:(void (^)(NSDictionary *))success
                      fail:(void (^)(NSString *))fail{
    
    [_curParamDict addEntriesFromDictionary:param];
    
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_NEW_BY_TIME]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self requestCommunitMsg:_curParamDict
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
