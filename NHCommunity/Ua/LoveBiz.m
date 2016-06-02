//
//  LoveBiz.m
//  NHCommunity
//
//  Created by aa on 16/3/21.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "LoveBiz.h"

@implementation LoveBiz
- (void)requestLoveMsg:(NSDictionary *)param
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
                                                           [self requestLoveMsg:_curParamDict
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
@end
