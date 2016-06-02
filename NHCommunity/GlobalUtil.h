//
//  GlobalUtil.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/22.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfoVo.h"

@interface GlobalUtil : NSObject

+ (instancetype)shareInstant;

- (void)saveUserName:(NSString *)uname
                 pwd:(NSString *)pwd;

- (NSDictionary *)loginInfo;

- (BOOL)isLogin;

- (void)setLogin:(BOOL)flag;

- (UserInfoVo *)userInfo;
- (void)setUserInfo:(UserInfoVo *)vo;

- (BOOL)loginWithCus;
- (void)setLoginWithCus:(BOOL)flag;
@end
