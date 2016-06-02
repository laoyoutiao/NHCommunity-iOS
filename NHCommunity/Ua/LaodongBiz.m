//
//  LaodongBiz.m
//  NHCommunity
//
//  Created by aa on 16/3/20.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "LaodongBiz.h"

@implementation LaodongBiz
- (void)requesLDBH:(NSDictionary *)param
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
                                                           [self requesLDBH:_curParamDict
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
