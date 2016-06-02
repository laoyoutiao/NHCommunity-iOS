//
//  UserBiz.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/15.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "UserBiz.h"
#import "TransformObjDict.h"
#import "UserInfoVo.h"

@implementation UserBiz

- (void)requestUserInfo:(NSDictionary *)param
                success:(void (^)(UserInfoVo *))success
                   fail:(void (^)(NSString *))fail{
    if (_curParamDict.count == 0 ) {
        [_curParamDict addEntriesFromDictionary:param];
    }
    
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_USER_INFO]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self requestUserInfo:   _curParamDict
                                                                       success:success
                                                                          fail:fail];
                                                       }else{
                                                           fail(responObject[DATA_KEY_MSG]);
                                                       }
                                                   }else{
                                                       NSLog(@"requestUserInfo respoint = %@",responObject);
                                                       UserInfoVo *vo = [TransformObjDict objectWithDict:responObject[DATA_KEY_DATA] theClass:[UserInfoVo class]];
                                                       [[GlobalUtil shareInstant] setUserInfo:vo];
                                                       success(vo);
                                                   }
                                                   
                                               } fail:^(NSError *error) {
                                                   fail(@"请求失败，请稍后再试!");
                                               }];
}

- (void)updatetUserInfo:(NSDictionary *)param
                success:(void (^)(NSString *))success
                   fail:(void (^)(NSString *))fail{
    if (_curParamDict.count == 0 ) {
        [_curParamDict addEntriesFromDictionary:param];
    }
    NSLog(@"用户信息保存请求参数= %@",param);
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_UPDATE_USER_INFO]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self updatetUserInfo:_curParamDict
                                                                         success:success
                                                                            fail:fail];
                                                       }else{
                                                           fail(responObject[DATA_KEY_MSG]);
                                                       }
                                                   }else{
                                                       NSLog(@"保存用户信息 成功  = %@",responObject);
                                                       
                                                       success(responObject[DATA_KEY_MSG]);
                                                       
                                                   }
                                                   
                                               } fail:^(NSError *error) {
                                                   fail(@"请求失败，请稍后再试!");
                                               }];
}

- (void)uploadHeadImage:(NSDictionary *)param
                success:(void (^)(NSString *))success
                   fail:(void (^)(NSString *))fail{
    if (_curParamDict.count == 0 ) {
        [_curParamDict addEntriesFromDictionary:param];
    }
    
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_UPLOAD_IMAGE]
                                                 param:_curParamDict
                                               success:^(id responObject) {
                                                   NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                   if (reRequest != nil) {
                                                       BOOL reFlag = reRequest.boolValue;
                                                       if (reFlag) {
                                                           [self uploadHeadImage:_curParamDict
                                                                         success:success
                                                                            fail:fail];
                                                       }else{
                                                           fail(responObject[DATA_KEY_MSG]);
                                                       }
                                                   }else{
//                                                       NSLog(@"uploadHeadImage respoint = %@",responObject);
                                                       
                                                       success(responObject[DATA_KEY_MSG]);
                                                       
                                                   }
                                                   
                                               } fail:^(NSError *error) {
                                                   fail(@"请求失败，请稍后再试!");
                                               }];
}
@end
