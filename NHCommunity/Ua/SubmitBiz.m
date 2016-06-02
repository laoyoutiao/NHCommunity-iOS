//
//  SubmitBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/10.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "SubmitBiz.h"
#import "HttpManager.h"
@implementation SubmitBiz

- (void)submitData:(NSDictionary *)param
           success:(void (^)(NSDictionary *))success
              fail:(void (^)(NSString *))fail{
    if (_curParamDict.count == 0) {
        [_curParamDict addEntriesFromDictionary:param];
    }

//    NSLog(@"subdata = %@",_curParamDict);
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_ADD_GUEST_BOOK]
                                                 param:param
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self submitData:_curParamDict
                                                                    success:success
                                                                       fail:fail];
                                                       }else{
                                                           fail(responObject[DATA_KEY_MSG]);
                                                       }
                                                   }else{
//                                                       NSLog(@"final respoint = %@",responObject);
                                                       success(responObject);
                                                   }
                                               }
                                                  fail:^(NSError *error) {
                                                      NSLog(@"subimt error = %@",error);
                                                       fail(@"请求失败，请稍后再试!");
    }];
}
@end
