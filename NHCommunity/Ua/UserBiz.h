//
//  UserBiz.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/15.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseBiz.h"
@class UserInfoVo;

@interface UserBiz : BaseBiz

- (void)requestUserInfo:(NSDictionary *)param
                success:(void(^)(UserInfoVo *responseObj))success
                   fail:(void(^)(NSString *errorMsg))fail;

- (void)updatetUserInfo:(NSDictionary *)param
                success:(void (^)(NSString *))success
                   fail:(void (^)(NSString *))fail;

- (void)uploadHeadImage:(NSDictionary *)param
                success:(void (^)(NSString *))success
                   fail:(void (^)(NSString *))fail;
@end
